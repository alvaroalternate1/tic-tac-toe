class TicTacToe
    def initialize
        @board = Array.new(3) { Array.new(3, " ") }
        @current_player = "X"
    end

    def play
        loop do
            print_board
            if @current_player == "O"
                ai_move
            else
                player_move
            end
            if winner?
                print_board
                puts "Player #{@current_player} wins!"
                break
            elsif draw?
                print_board
                puts "It's a draw!"
                break
            end
            switch_player
        end
    end

    private

    def print_board
        puts
        # Print column headers
        print "    "
        (1..3).each { |col| print " #{col}  " }
        puts
        puts "   +---+---+---+"
        @board.each_with_index do |row, i|
            # Print row number before the row
            print " #{i+1} |"
            print row.map { |cell| " #{cell} " }.join("|")
            puts "|"
            puts "   +---+---+---+" 
        end
        puts
    end

    def player_move
        loop do
            print "Player #{@current_player}, enter row and column (e.g. 1 2): "
            input = gets.chomp
            row, col = input.split.map { |x| x.to_i - 1 }
            if valid_move?(row, col)
                @board[row][col] = @current_player
                break
            else
                puts "Invalid move. Try again."
            end
        end
    end

    def ai_move
        # Try to win
        move = find_best_move("O")
        if move
            row, col = move
            puts "AI (O) chooses: #{row+1} #{col+1}"
            @board[row][col] = "O"
            return
        end

        # Try to block player from winning
        move = find_best_move("X")
        if move
            row, col = move
            puts "AI (O) chooses: #{row+1} #{col+1}"
            @board[row][col] = "O"
            return
        end

        # Otherwise, pick the first available cell
        (0..2).each do |row|
            (0..2).each do |col|
                if valid_move?(row, col)
                    puts "AI (O) chooses: #{row+1} #{col+1}"
                    @board[row][col] = "O"
                    return
                end
            end
        end
    end

    def find_best_move(player)
        # Check all cells, simulate move, and see if it results in a win for 'player'
        (0..2).each do |row|
            (0..2).each do |col|
                if valid_move?(row, col)
                    @board[row][col] = player
                    win = winner_for?(player)
                    @board[row][col] = " "
                    return [row, col] if win
                end
            end
        end
        nil
    end

    def winner_for?(player)
        lines = @board + @board.transpose +
                [[@board[0][0], @board[1][1], @board[2][2]],
                 [@board[0][2], @board[1][1], @board[2][0]]]
        lines.any? { |line| line.all? { |cell| cell == player } }
    end

    def valid_move?(row, col)
        row.between?(0,2) && col.between?(0,2) && @board[row][col] == " "
    end

    def winner?
        lines = @board + @board.transpose +
                        [[@board[0][0], @board[1][1], @board[2][2]],
                         [@board[0][2], @board[1][1], @board[2][0]]]
        lines.any? { |line| line.all? { |cell| cell == @current_player } }
    end

    def draw?
        @board.flatten.none? { |cell| cell == " " }
    end

    def switch_player
        @current_player = @current_player == "X" ? "O" : "X"
    end
end

if __FILE__ == $0
    game = TicTacToe.new
    game.play
end