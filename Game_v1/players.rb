class Players
  attr_reader :name
  def initialize(name)
    @name=name
  end

  def guess
    gets.chomp.downcase
  end

  def alert_invalide_guess
    p "This is an invalid guess. Please make sure it's a letter form the alphabet!"
  end

end
