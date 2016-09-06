
def make_a_choice
   puts "ALASTRA".center(31).red

   welcomeMsg = <<~HEREDOC
     Macera Başlasın Al Ejder ALASTRA için savaşacaksın!
     Başlamadan önce söyle bakalım: Bir büyücü müsün bir
     savaşçı mı yoksa ejderhanın hazinesinin peşindeki
     bir hırsız mısın?\n\n
   HEREDOC

   welcomeMsg.each_char do |c|
     sleep 0.2
     print c.green
   end

   menu = [["Savaşçı", 1], ["Büyücü", 2], ["Hırsız", 3]]

   selection_table = Terminal::Table.new :title => "Karakter Seçimi", :headings => ['Kahraman Sınıfı', 'Seçim Tuşu'], :rows => menu
   selection_table.style = {:width => 40, :padding_left => 3, :border_x => "*", :border_i => "#"}

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
     "Tanımsız"
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

def defaultData
  json = File.read("hero.json")
  defaultDataHash = JSON.parse(json)
  return defaultDataHash
end

def newHERO(choice = [], details = {})
    _Guild, _Name, _Gender = choice[0], choice[1], choice[2]
    _Details = details[_Guild]
    saveHash = {"guild" => _Guild, "name" => _Name, "gender" => _Gender, "details" => _Details}
    player = Player.new(_Guild, _Name, _Gender, _Details)
    return player, saveHash
end

def newHeroInfo(player)
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
end

def heroInfo(hero)
  unless hero
    puts "Kahraman bir sorun var!"
  else
    newHeroInfo(hero)
  end
end
