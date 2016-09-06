
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
  :armorGuild

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
class	Game < Player
  include(Dice)
  include(Game_Objects)

  def	initialize(player, world)
    @player = player
    @woeld = world
		start_game
	end

  def game_over
    puts "Kahraman öldü, haliyle kahraman ölünce biz de ölmüş sayıldık."
  end

	def	walk(steps_to_take)
      puts	"Kahraman	#{@steps_taken} adım attı."
      @steps_taken	+=	steps_to_take
	end
end
