import 'dart:async';
import 'dart:io';
import 'dart:math';

const int boardWidth = 20; // Width of the game board
const int boardHeight = 10; // Height of the game board

class Game {
  List<List<String>> board;
  List<Position> lizard;
  Position food; // This will be initialized in the constructor
  int growthCounter = 0;

  Game()
      : board = List.generate(boardHeight, (_) => List.filled(boardWidth, ' ')),
        lizard = [Position(5, 5)],
        food = Position(0, 0) { // Initializing food to a default value
    placeFood(); // Place food right after initializing
  }

  void placeFood() {
    Random random = Random();
    int x, y;

    do {
      x = random.nextInt(boardWidth);
      y = random.nextInt(boardHeight);
    } while (board[y][x] != ' ');

    food = Position(x, y);
  }

  void drawBoard() {
    // Clear the console
    print('\x1B[2J\x1B[0;0H');

    for (int y = 0; y < boardHeight; y++) {
      for (int x = 0; x < boardWidth; x++) {
        if (lizard.contains(Position(x, y))) {
          // Draw the lizard
          if (lizard.indexOf(Position(x, y)) == 0) {
            stdout.write('*'); // Head of the lizard
          } else {
            stdout.write('*'); // Body of the lizard
          }
        } else if (food == Position(x, y)) {
          stdout.write('@'); // Food
        } else {
          stdout.write(' '); // Empty space
        }
      }
      print(''); // New line after each row
    }
  }

  void moveLizard() {
    Position head = lizard.first;

    // Determine direction towards food
    int dx = (food.x - head.x).sign;
    int dy = (food.y - head.y).sign;

    // Move head
    Position newHead = Position(head.x + dx, head.y + dy);

    // Check for collisions
    if (isCollision(newHead)) {
      print('Game Over! The lizard collided with itself or the wall.');
      exit(0);
    }

    lizard.insert(0, newHead); // Add new head position

    // Check if the lizard eats the food
    if (newHead == food) {
      growthCounter++; // Increment growth counter
      placeFood(); // Place new food
    } else {
      lizard.removeLast(); // Remove the last segment if not eating
    }
  }

  bool isCollision(Position newHead) {
    // Check if the new head position collides with the wall or itself
    return newHead.x < 0 || newHead.x >= boardWidth ||
           newHead.y < 0 || newHead.y >= boardHeight ||
           lizard.skip(1).contains(newHead); // Skip head when checking for self-collision
  }

  void run() {
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      moveLizard();
      drawBoard();
    });
  }
}

class Position {
  final int x;
  final int y;

  Position(this.x, this.y);

  @override
  bool operator ==(Object other) {
    return other is Position && other.x == x && other.y == y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}

void main() {
  Game game = Game();
  game.drawBoard();
  game.run();
}
