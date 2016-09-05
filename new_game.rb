require 'terminal-table'
require 'colorize'
require_relative 'initializations'



def new_hero
   puts "ALASTRA".center(31).red

   welcomeMsg = <<~HEREDOC
     Macera Başlasın Al Ejder ALASTRA için savaşacaksın!
     Başlamadan önce söyle bakalım: Bir büyücü müsün bir
     savaşçı mı yoksa ejderhanın hazinesinin peşindeki
     bir hırsız mısın?\n\n
   HEREDOC

   welcomeMsg.each_char do |c|
     sleep 0.15
     print c.green
   end


   sleep 0.6

   menu = [["Savaşçı", 1], ["Büyücü", 2], ["Hırsız", 3]]

   selection_table = Terminal::Table.new :title => "Karakter Seçimi", :headings => ['Kahraman Sınıfı', 'Seçim Tuşu'], :rows => menu
   selection_table.style = {:width => 40, :padding_left => 3, :border_x => "*", :border_i => "#"}

   sleep 0.5
   puts selection_table

   print "\nSeçimin: ".green
   choice = gets.chomp

   puts "Adını bağışla cesur #{menu[choice.to_i - 1][0]}".blue
   name = gets.chomp.capitalize

   print "\n#{name} isimli cesur #{menu[choice.to_i - 1][0]} bir? :\n"
   puts "Kadın için 'K' Erker için 'E' Gökkuşağı için 'G'"
   genderQ = gets.chomp.downcase
   gender = case genderQ
   when 'k'
     "Kadın"
   when 'e'
     "Erkek"
   when 'g'
     "Lgbt"
   else
     puts "Tanımsız bir cinsiyet girdiğiniz için cinsiyet 'Tanımsız' olarak belirlendi."
     return "Tanımsız"
   end

   case choice
      when "1"
       return "warrior", name, gender
      when "2"
       return "mage", name, gender
      when "3"
       return "thief", name, gender
   end

end

details = {
  "warrior": {
     health: 160,
     strngth: 14,
     dex:5,
     vital: 11,
     mana: 4,
     wpn: {"name":"sword_casual", damage: 1.2, "guild": "warrior", "element": nil,"description": "Hiç yoktan iyidir."},
     arm: {"name": "armor_casual", defense: 1.9, "guild": "warrior", "description": "Dandiğinden bir armor"},
     abl: "earth"
 },
 "mage": {
     health: 100,
     strngth: 6,
     dex:9,
     vital: 8,
     mana: 14,
     wpn: {"name":"staff_casual", damage: 2.4, "guild": "mage", "element": nil,"description": "Hiç yoktan iyidir."},
     arm: {"name": "armor_casual", defense: 0.9, "guild": "mage", "description": "Dandiğinden bir armor"},
     abl: "fire"
 },
 "thief": {
   health: 120,
   strngth: 9,
   dex:14,
   vital: 9,
   mana: 5,
   wpn: {"name":"dagger_casual", damage: 1.2, "guild": "thief", "element": nil,"description": "Hiç yoktan iyidir."},
   arm: {"name": "armor_casual", defense: 0.9, "guild": "mage", "description": "Dandiğinden bir armor"},
   abl: "wind"
 }
}
choice = new_hero

def newHERO(*choice)
    _Guild = choice[0]
    _Name = choice[1]
    _Gender = choice[2]
    _Details = details[_Guild.to_sym]

  player = Player.new(_Guild, _Name, _Gender, _Details)

  puts "Kahraman ALASTRA klanına katıldı!"

  arr_playerINFO =[["İsim", player.name],
  ["HP",         player.health],
  ["Strength",   player.strngth],
  ["Dexterity",  player.dex],
  ["Vitality",   player.vital],
  ["Mana",       player.mana],
  ["Silah",      player.weaponName],
  ["Vuruş Gücü", player.wpDamage],
  ["Zırh",       player.armorName],
  ["Savunma",    player.defense],
  ["Cinsiyet",   player.gender],
  ["Yetenek",    player.ability]]

  player_table = Terminal::Table.new :title => "KAHRAMAN BİLGİSİ", :headings => ['Özellik', 'Değer'], :rows => arr_playerINFO
  player_table.style = {:width => 40, :padding_left => 3, :border_x => "=", :border_i => "X"}
  puts player_table
  return player
end

pc_player = newHERO(choice)
