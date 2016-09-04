# -*- coding: utf-8 -*-
require 'json'

module Dice
  def roll_dice(dice_type)
    highest = dice_type == "action" ? 20 : 10
    value = Array(0..highest).repeated_permutation(1).to_a.shuffle
    value.at(Range(value.length + 1))
  end

  def success_dice(value)
    case value
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

  def damage_value(atack,success)
    unless success
      ad = 0
    else
      ad = atack * success
    end
    ad
  end
end

module  Game_Objects
  def defensed(armor, armorGuild)
    dBonus = self.guild == armorGuild ? (armor/2) : 0
    defensePwr = armor + dBonus
  end

  def attack(weaponDmg, dmgValue, wpnGuild)
    aBonus = self.guild == wpnGuild ? (weaponDmg/2) : 0
    atck_pwr = (weaponDmg * dmgValue)  + gBonus
  end

  def weapon(wp_name)
    tht_wpn = Hash.new
    wp_hash = JSON.parse(File.read("weapons.json"))
    tht_wpn.push(wp_hash[wp_name])
    return tht_wpn
  end
  end


class Player
include(Dice)

  attr_reader :name, :guild, :gender, :ability
  attr_accessor :health, :strngth, :dex, :vital, :weapon, :armor, :damage, :healimg
  @@crew = 0
  def initialize(name, guild, details = {})
    @name = name
    @guild = guild
    @health = details['hp']
    @strngth = details['strngth']
    @dex = details['dex']
    @vital = details['vit']
    @weapon = details['wpn']
    @wpDamage = @weapon["damage"]
    @armor = details['arm']
    @gender = details['gender']
    @ability = details['abl']
    @@crew += 1
  end

  def healimg(value)
    self.health += value
  end

  def demage(value)
    self.health -= value
  end

  def is_alive?
    return false if self.health <= 0
    true
  end
end