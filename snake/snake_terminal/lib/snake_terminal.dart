import 'dart:io';
import 'dart:async';
import 'dart:math';

const int width = 20;
const int height = 20;
List<List<String>> grid = List.generate(height, (_) => List.generate(width, (_) => ' '));
List<Point<int>> snake = [Point(10, 10)];
Point<int> food = Point(5, 5);
String direction = 'right';
bool gameOver = false;

void main() {
  stdin.echoMode = false;
  stdin.lineMode = false;

  spawnFood();
  Timer.periodic(Duration(milliseconds: 200), (timer) {
    if (gameOver) {
      print('Game Over! Score: ${snake.length}');
      timer.cancel();
      exit(0);
    } else {
      update();
      draw();
    }
  });

  stdin.listen((List<int> input) {
    handleInput(input.first);
  });
}

void spawnFood() {
  Random random = Random();
  food = Point(random.nextInt(width), random.nextInt(height));
}

void handleInput(int keyCode) {
  switch (keyCode) {
    case 119: // w
      if (direction != 'down') direction = 'up';
      break;
    case 115: // s
      if (direction != 'up') direction = 'down';
      break;
    case 97: // a
      if (direction != 'right') direction = 'left';
      break;
    case 100: // d
      if (direction != 'left') direction = 'right';
      break;
  }
}

void update() {
  Point<int> newHead;

  switch (direction) {
    case 'up':
      newHead = Point(snake.first.x, (snake.first.y - 1 + height) % height);
      break;
    case 'down':
      newHead = Point(snake.first.x, (snake.first.y + 1) % height);
      break;
    case 'left':
      newHead = Point((snake.first.x - 1 + width) % width, snake.first.y);
      break;
    case 'right':
    default:
      newHead = Point((snake.first.x + 1) % width, snake.first.y);
      break;
  }

  if (newHead == food) {
    snake.insert(0, newHead);
    spawnFood();
  } else {
    snake.insert(0, newHead);
    snake.removeLast();
  }

  if (snake.skip(1).contains(newHead)) {
    gameOver = true;
  }
}

void draw() {
  stdout.write('\x1B[2J\x1B[0;0H'); // Clear screen

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      if (snake.contains(Point(x, y))) {
        stdout.write('O'); // Snake body
      } else if (food == Point(x, y)) {
        stdout.write('X'); // Food
      } else {
        stdout.write(' '); // Empty space
      }
    }
    stdout.writeln();
  }

  print('Score: ${snake.length}');
}
