# frozen_string_literal: true

require "./Deck"
require "./Menu"
require "./Player"
require "./CPU"
require "./Dealer"

class Main
  def initialize
    puts "CPUを何人追加しますか?(0~3を入力してください)"
    loop do
      @playernumber = gets.to_i
      case @playernumber
      when 0..3
        break
      else
        puts "2または3または4を入力してください"
      end
    end
    @player1 = Player.new()
    @playercpu1 = CPU.new()
    @playercpu2 = CPU.new()
    @playercpu3 = CPU.new()
    @dealer = Dealer.new()

    @menu = Menu.new()
    @deck = Deck.new()
  end

  def main
    loop do
      # Playerのベットタイミング
      @player1.bet

      # Playerのカードドロー
      @player1.drawtwice(@menu, @deck)
      @player1.surrender(@menu)
      # Playerがサレンダーした場合ゲームを終了させる
      if @player1.getSurrenderFlg == false
        @playercpu1.drawtwice(@menu, @deck) if @playernumber >= 1
        @playercpu2.drawtwice(@menu, @deck) if @playernumber >= 2
        @playercpu3.drawtwice(@menu, @deck) if @playernumber >= 3

        # Dealerのカードドロー
        @dealer.drawtwice(@menu, @deck)

        # Playerが複数回カードドロー
        @player1.drawloop(@menu, @deck)

        # Playerの得点が21を超えた場合ゲーム終了させる
        if @player1.getOverFlg == false
          @playercpu1.drawloop(@deck) if @playernumber >= 1
          @playercpu2.drawloop(@deck) if @playernumber >= 2
          @playercpu3.drawloop(@deck) if @playernumber >= 3
          
          # Dealerが複数回カードドロー
          @dealer.drawloop(@deck)

          # PlayerとDealerの得点比較
          @menu.showPoint(@player1)
          @menu.showCPUPoint(@playercpu1) if @playernumber >= 1
          @menu.showCPUPoint(@playercpu2) if @playernumber >= 2
          @menu.showCPUPoint(@playercpu3) if @playernumber >= 3
          @menu.showPoint(@dealer)
          compareFinalPoint(@player1, @dealer)
          compareFinalPoint(@playercpu1, @dealer) if @playernumber >= 1
          compareFinalPoint(@playercpu2, @dealer) if @playernumber >= 2
          compareFinalPoint(@playercpu3, @dealer) if @playernumber >= 3
        else
          compareFinalPoint(@player1, @dealer)
        end
      else
        @menu.showJudgeEndGame(false, @player1)
      end

      loop do
        @menu.continueGame()
        key = gets.chomp
        if key == "Y"
          @deck.initializeDeck()
          @deck.generateDeck()
          @player1.clearUserInfo()
          @playercpu2.clearUserInfo()
          @playercpu3.clearUserInfo()
          @dealer.clearUserInfo()
          break
        elsif key == "N"
          @menu.showEndGame()
          exit
        else
          menu.showCheckYesorNo
        end
      end
    end
  end

  def compareFinalPoint(player, dealer)
    playerpoint = player.getUserPoint
    dealerpoint = dealer.getUserPoint
    if (dealerpoint >= 22) || (dealerpoint <= 21 && playerpoint <= 21 && playerpoint >= dealerpoint)
      @menu.showJudgeEndGame(true, player)
      player.winGame if player.instance_of?(Player)
    else
      @menu.showJudgeEndGame(false, player)
    end
  end
end

main = Main.new()
main.main()
