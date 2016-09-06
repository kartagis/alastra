
module Dice
  def roll_dice(dice_type="action")
    highest = dice_type == "action" ? 20 : 10
    value = Array(0..highest).repeated_permutation(1).to_a.shuffle
    point = value.at(Range(value.length + 1))
    return point
  end

  def success_dice
    self.point = roll_dice unless self.point
    case self.point
      when 19..20
        1
      when 15-18
        0.75
      when 10-14
        0.10
      when 0..4
        false
      else
        puts "Delirmiş olmalı! Ne yapıyor bu?"
    end
  end

  def damage_value
    unless self.success_dice
      ad = 0
    else
      ad = atack * success
    end
     ad
  end
end

module  Game_Objects
  def defensed
    dBonus = self.guild == self.armorGuild ? (self.defense/2) : 0
    defensePwr = self.defense + dBonus
    return defensePwr
  end

  def attackValue
    aBonus = self.guild == self.wpnGuild ? (self.wpDamage/2) : 0
    atck_value = (self.wpDamage * self.damage_value)  + gBonus
    return atck_value
  end

  def weapon
    tht_wpn = Hash.new
    wp_hash = JSON.parse(File.read("weapons.json"))
    tht_wpn = wp_hash.sample
    return tht_wpn
  end

  def damage_taken(attackValue, defensed)
    hit = attackValue - defensed
    return hit
  end
end


class Player
  attr_reader :name, :guild, :gender, :ability
  attr_accessor :health, :strngth, :dex, :vital, :defense, :healed,
  :mana, :weapon, :armor, :weaponName, :armorName, :wpDamage, :dicePoint, :exp,
  :armorGuild, :x_coord, :y_coord

  include(Dice)
  include(Game_Objects)

  @@crew = 0
  def initialize(guild, name, gender, details)
    @guild = guild
    @name = name
    @gender = gender
    @health = details["health"]
    @strngth = details["strngth"]
    @dex = details["dex"]
    @vital = details["vital"]
    @mana = details["mana"]
    @weapon = details["wpn"]
    @weaponName = @weapon["name"]
    @wpDamage = @weapon["damage"]
    @wpnGuild = @weapon["guild"]
    @armor = details["arm"]
    @armorName = @armor["name"]
    @defense = @armor["defense"]
    @armorGuild = @armor["guild"]
    @ability = details["abl"]
    @dicePoint = 0
    @exp = 0
    @x_coord, @y_coord = 0, 0
    @@crew += 1
  end

  def healed(value)
    self.health += value
  end

  def demaged(hit)
    self.health -= hit
  end


  def is_alive?
    return false if self.health <= 0
    true
  end

  def player_status
    puts "*" * 120
    puts "Sağlık Durumu : #{@health}"
    puts "*" * 120
  end
end

class Item
  TYPES = ["potion", "sword", "staff"]
  attr_accessor :type

  def initialize
    @type = TYPES.sample
  end

  def interact(player)
    case @type
    when "potion"
      player.healed(10)
    when "sword", "staff", "bow"
      player.point = roll_dice unless player.point
      hit = player.attackValue
    end
  end

  def to_S
    "Bir #{@type.to_s} buldun."
  end
end
class Monster
  include(Dice)
  include(Game_Objects)

  attr_accessor :hp, :wpDamage, :point, :wpDamage, :wpnGuild
  MAX_HP = (100..160).to_a.sample.to_i

  def initialize
    @hp = MAX_HP
    @point = 0
    @wpDamage = (1..26).to_a.sample.to_i
    @wpnGuild = nil
    @guild = "monster"

  end

  def mnsdamaged(amount)
    @hp -= amount
  end

  def interact(player)
    while player.is_alive?
      player.point = roll_dice
      hit = player.attackValue

      if hit > 5
        puts "Canavara tam olarak #{hit} şiddetinde bir tane çaktık."
      else
        puts "Hay ben böyle şansı s..."
      end

      mnsdamaged(hit)
      break unless self.is_alive?

      self.point = roll_dice
      mAttack = self.attackValue

      if mAttack > 5
        puts "Off! sağlam geçirdi Tam tamına #{mAttack} çaktı!"
      else
        puts "Pwww!.. iyi yırttık, ıskaladı zevzek."
      end

     defensePoint = player.defensed
     dmgTaken = damage_taken(mAttack, defensePoint)
     player.damaged(dmgTaken)
    end
  end
end

class world
  WORLD_X = 36
  WORLD_Y = 36

  def initialize
    @rooms = Array.new(WORLD_Y, Array.new(WORLD_X))
  end

  def move_entity_up(entity)
    entity.y_coord -= 1 if entity.y_coord > 0
  end

  def move_entity_down(entity)
    entity.y_coord += 1 entity.y_coord < WORLD_Y - 1
  end

  def move_entity_right(entity)
    entity.x_coord += 1 if entity.x_coord < WORLD_X - 1
  end

  def move_entity_left(entity)
    entity.x_coord -=1 if entity.x_coord > 0
    end

    def get_room_of(entity)
      @room[entity.x_coord][entity.y_coord] ||= Room.new
    end
end

class Room
  attr_accessor :size, content

  def initialize
    @content = get_content
    @size = get_size
    @adjective = get_adjective
  end

  def interact(player)
    if @content
      @content.interect(player)
      @content = nil
    end
  end

  def to_s
    "Bir #{size} büyüklükte odacıktasın ey kahraman. Odayı keşfetmeyi bizden öğrenecek değilsin."
  end

  private
  def get_content
    [Monster, Item].sample.new
  end

  def get_size
    ["Daracık", "Gecekondu tadında", "Yuh artık görmemiş kralın abartı sarayı"].sample
  end


end

class	Game < Player
  include(Dice)
  include(Game_Objects)

  ACTIONS = ["ileri", "sağ", "geri", "sol", "bak", "vur", "al", "durum"]

  def	initialize(player, world)
    @player = player
    @world = world

    start_game
  end

  private
  def start_game
    while @player.is_alive?
      @current_room = @world.get_room_of(@player)

      player_status

      action = take_player_input
      next unless ACTINONS.include? action

      take_action(action)
    end
  end


  def take_player_input
    print "Bir sonraki hamlen ne olacak bakalım kahraman #{@player.name} : "
    gets.chomp.to_sym
  end

  def print_place
    puts "Şu an ki harita koordinatlarımız: #{@player.x_coord}, #{@player.y_coord}"
    puts @current_room
    if @current_room.content
      put "Bak görüyor musun, orada bir #{@current_room.content} var."
    end
  end

  def take_action(action)
    case action
      when
      when "bak"
        print_place
      when "ileri"
        @world.move_entity_up(@player)
      when "sağ"
        @world.move_entity_right(@player)
      when "geri"
        @world.move_entity_down(@player)
      when "sol"
        @world.move_entity_left(@player)
      when "al", "vur"
        @current_room.interect(@player)
      when "durum"
        @player.player_status
    end
  end
  
  def game_over
    puts "Kahraman öldü, haliyle kahraman ölünce biz de ölmüş sayıldık."
  end

end
