require_relative 'file_controls'

def gameMenu
  menu = [["Yeni Oyun", 1], ["Son Oyunu Yükle", 2]]

  game_menu = Terminal::Table.new :title => "OYUN MENÜSÜ", :headings => ['Menü Ögesi', 'Seçim Tuşu'], :rows => menu
  game_menu.style = {:width => 40, :padding_left => 3, :border_x => "*", :border_i => "#"}

  puts game_menu

  puts "Şeçim UYARI : 'Yeni Oyun' bir önceki kahraman kaydını siler!"
  picked_menuItem = gets.chomp

  case picked_menuItem
  when "1"
    details = Hash(*defaultData)
    choice = make_a_choice
    $_Player1 = newHERO(choice, details)
    saveHero($_Player1)
  when "2"
    $_Player1 = loadGame
    saveHero($_Player1)
  else
    puts "Hatalı bir seçim yaptınız tekrar deneyin."
    gameMenu
  end
end

gameMenu
