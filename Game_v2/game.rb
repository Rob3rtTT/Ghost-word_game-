require_relative 'players.rb'
require 'set'
class Game
    def initialize(*players)
        @players=players
        @fragment=""
        file = File.readlines('./dictionary.txt').map(&:chomp)
        @dictionary = Set.new(file)
        @losses=Hash.new{0}
    end

    def run
        until @players.size == 1
            leaderboard
            play_round
            @players.each do |player|
                if @losses[player]==5
                    @players.delete(player)
                end
            end
        end
        p "#{@players.first.name} has won!!!"
        return true
    end

    def play_round
        system("clear")
        until @dictionary.include?(@fragment)
            take_turn(current_player)
        end
        p "#{previous_player.name} has lost"
        @losses[previous_player]+=1
        record(previous_player)
        sleep(2)
        self.reset!
    end

    def current_player
        @players.first
    end

    def previous_player
        @players.last
    end

    def next_player!
        @players.rotate!
    end

    def take_turn(player)
        p "Fragment '#{@fragment}'"
        p "#{current_player.name} please enter your guess"
        p_guess=player.guess
        until valid_play?(p_guess)
            player.alert_invalide_guess
            self.take_turn(player)
            return false
        end
        @fragment+=p_guess
        self.next_player!
    end

    def valid_play?(string)
        alphabet=("a".."z").to_a
        if alphabet.include?(string) && @dictionary.any?{|word| word.start_with?(@fragment+string)}
            return true
        end
        # if @dictionary.include?(@fragment+=string)
        #     return true
        # end
        false
    end

    def record(player)
        string = "GHOST"
        length=@losses[player]
        p "#{player.name}: #{string[0...length]}"
    end


    def reset!
        system("clear")
        @fragment=""
        @players.sort_by!{|player| player.name}
    end

    def leaderboard
        system("clear")
        string="GHOST"
        @players.each do |player|
            p "#{player.name}: #{string[0...@losses[player]]}"
        end
        sleep(3)
    end

end


game = Game.new(
    Players.new('p1'),
    Players.new('p2'),
    Players.new('p3'),
    Players.new('p4')
)

game.run
