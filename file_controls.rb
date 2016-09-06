require_relative 'new_game'

def saveGame(saveData)
  hashArray = saveData.to_a
  File.open("save.json", "w") do |f|
    f.puts JSON.pretty_generate(hashArray)
  end
  puts "Kahraman kaydedildi."
end

def saveHero(heroData)
  heroInfo(heroData[0])
  saveData = heroData[1]
  saveGame(saveData)
end

def loadGame
  loadJson = File.read("save.json")
  loadHash = Hash(*JSON.parse(loadJson))
  _Player1 = Player.new(loadHash["guild"], loadHash["name"], loadHash["gender"], loadHash["details"])
  return _Player1
end
