

def saveGame(saveData)
  hashJson = saveData.to_json
  File.open("save.json", "w") do |f|
    f.puts hashJson
  end
  puts "Kahraman kaydedildi."
end

def saveHero(heroData)
  heroInfo(heroData[0])
  saveData = heroData[1]
  saveGame(saveData)
end

def load_user_lib( filename )
  JSON.parse( IO.read(filename) )
end


def loadGame
  loadHash = JSON.parse( IO.read("save.json", encoding:'utf-8') )
  _Player1 = Player.new(loadHash["guild"], loadHash["name"], loadHash["gender"], loadHash["details"])
  heroInfo(_Player1)
  saveGame(loadHash)
  return _Player1
end
