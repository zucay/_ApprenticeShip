# frozen_string_literal: true

require "./Deck"
require "./Menu"
require "./Player"
require "./CPU"
require "./Dealer"

class Main
  def initialize
    puts "何人でプレイしますか?(2または3または4を入力してください)"
    loop do
      @playernumber = gets.to_i
      case @playernumber
      when 2
        puts "2"
        break
      when 3
        puts "3"
        break
      when 4
        puts "4"
        break
      else
        puts "2または3または4を入力してください"
      end
    end

    @player1 = Player.new()
    @playercpu2 = CPU.new()
    @playercpu3 = CPU.new()
    @dealer = Dealer.new()

    @menu = Menu.new()
    @deck = Deck.new()
    @deck.shuffle()
  end

  def main
    # Playerのカードドロー
    @player1.drawtwice(@menu, @deck)
    @playercpu2.drawtwice(@menu, @deck) if @playernumber >= 3
    @playercpu3.drawtwice(@menu, @deck) if @playernumber >= 4

    # Dealerのカードドロー
    @dealer.drawtwice(@menu, @deck)

    # Playerが複数回カードドロー
    @player1.drawloop(@menu, @deck)
    @playercpu2.drawloop(@deck) if @playernumber >= 3
    @playercpu3.drawloop(@deck) if @playernumber >= 4

    # Dealerが複数回カードドロー
    @dealer.drawloop(@deck)

    # PlayerとDealerの得点比較
    @menu.showPoint(@player1)
    @menu.showCPUPoint(@playercpu2) if @playernumber >= 3
    @menu.showCPUPoint(@playercpu3) if @playernumber >= 4
    @menu.showPoint(@dealer)
    compareFinalPoint(@player1, @dealer)
    compareFinalPoint(@playercpu2, @dealer) if @playernumber >= 3
    compareFinalPoint(@playercpu3, @dealer) if @playernumber >= 4
    @menu.showEndGame()
  end

  def compareFinalPoint(player, dealer)
    if (dealer.getUserPoint >= 22 && player.getUserPoint <= 21) || (dealer.getUserPoint <= 21 && player.getUserPoint <= 21 && player.getUserPoint >= dealer.getUserPoint)
      @menu.showJudgeEndGame(true, player)
    else
      @menu.showJudgeEndGame(false, player)
    end
  end
end

main = Main.new()
main.main()
