/*
Ben Sherwin
Play CrossCribb against a computer!  
HOW TO PLAY:
  Standard rules of Cross Cribbage apply.
  Player 1 is the dealer.  P1 starts by going first and plays the verticals.
  Player 2 starts with the cribb and plays the horizontals.
  After every round, the player who starts and who gets the cribb will swap.
  
  Clicking the mouse anywhere on screen will either reveal the top card of
    the player's deck or prompt the computer to play, depending on whose
    turn it is.  If the top card of the human player's deck is revealed, then
    clicking on any open space on the grid or in the cribb will place the card.
    Click again to continue the game by either prompting the computer to play,
    or if the play was to place in the cribb, to reveal the player's next card.
  
DESCRIPTION:
  The computer uses probabilistic Monte Carlo Tree search to analyze how
  good each availible move is.  It plays each move, and simulates many different
  possible games.  The move that led to the most won games is chosen.  Since
  the computer does not know the order of the rest of the cards, or the contents
  of what the opponent put into the cribb, it guesses based on what cards are
  still availible.

Edit the following 2 variables below to suit the game to your taste!
**/

// If true, the human goes first, will play the verticals, and will not start with the cribb
// If false, the computer will go first, the human plays the horizontals and starts with the cribb.
boolean human_player_goes_first = true;

// Set computer difficulty on a scale of 1 to 5, where 1 is easy and 5 is hard.
// NOTE: higher difficulties will mean longer loading times for the computer.
int computer_difficulty = 3;

import java.util.*;

PImage[][] images; //[rank][suit] - c,d,h,s
PImage back;
Card c = null;
boolean b = false;
Deck d;
Game g;
boolean down = true;
MonteCarlo p;

void setup() {
  size(1400, 800);
  // Inintialize standard deck of cards
  ArrayList<Card> cards = new ArrayList<Card>(Arrays.asList(new Card(1, 's'), new Card(1, 'h'), new Card(1, 'd'), new Card(1, 'c'), 
    new Card(2, 's'), new Card(2, 'h'), new Card(2, 'd'), new Card(2, 'c'), 
    new Card(3, 's'), new Card(3, 'h'), new Card(3, 'd'), new Card(3, 'c'), 
    new Card(4, 's'), new Card(4, 'h'), new Card(4, 'd'), new Card(4, 'c'), 
    new Card(5, 's'), new Card(5, 'h'), new Card(5, 'd'), new Card(5, 'c'), 
    new Card(6, 's'), new Card(6, 'h'), new Card(6, 'd'), new Card(6, 'c'), 
    new Card(7, 's'), new Card(7, 'h'), new Card(7, 'd'), new Card(7, 'c'), 
    new Card(8, 's'), new Card(8, 'h'), new Card(8, 'd'), new Card(8, 'c'), 
    new Card(9, 's'), new Card(9, 'h'), new Card(9, 'd'), new Card(9, 'c'), 
    new Card(10, 's'), new Card(10, 'h'), new Card(10, 'd'), new Card(10, 'c'), 
    new Card(11, 's'), new Card(11, 'h'), new Card(11, 'd'), new Card(11, 'c'), 
    new Card(12, 's'), new Card(12, 'h'), new Card(12, 'd'), new Card(12, 'c'), 
    new Card(13, 's'), new Card(13, 'h'), new Card(13, 'd'), new Card(13, 'c')));
  images = new PImage[][] {{loadImage("AC.png"), loadImage("AD.png"), loadImage("AH.png"), loadImage("AS.png")}, 
    {loadImage("2C.png"), loadImage("2D.png"), loadImage("2H.png"), loadImage("2S.png")}, 
    {loadImage("3C.png"), loadImage("3D.png"), loadImage("3H.png"), loadImage("3S.png")}, 
    {loadImage("4C.png"), loadImage("4D.png"), loadImage("4H.png"), loadImage("4S.png")}, 
    {loadImage("5C.png"), loadImage("5D.png"), loadImage("5H.png"), loadImage("5S.png")}, 
    {loadImage("6C.png"), loadImage("6D.png"), loadImage("6H.png"), loadImage("6S.png")}, 
    {loadImage("7C.png"), loadImage("7D.png"), loadImage("7H.png"), loadImage("7S.png")}, 
    {loadImage("8C.png"), loadImage("8D.png"), loadImage("8H.png"), loadImage("8S.png")}, 
    {loadImage("9C.png"), loadImage("9D.png"), loadImage("9H.png"), loadImage("9S.png")}, 
    {loadImage("10C.png"), loadImage("10D.png"), loadImage("10H.png"), loadImage("10S.png")}, 
    {loadImage("JC.png"), loadImage("JD.png"), loadImage("JH.png"), loadImage("JS.png")}, 
    {loadImage("QC.png"), loadImage("QD.png"), loadImage("QH.png"), loadImage("QS.png")}, 
    {loadImage("KC.png"), loadImage("KD.png"), loadImage("KH.png"), loadImage("KS.png")}};
  back = loadImage("purple_back.png");

  d = new Deck(cards);
  d.shuffle();
  g = new Game(d);
  int dealer = 1;
  if (human_player_goes_first)  {
     dealer = 2; 
  }
  int diff = (int) (Math.pow(10, (computer_difficulty + 1) / 2));
  if(computer_difficulty % 2 == 0) diff *= 5;
  println(diff);
  p = new MonteCarlo(g, diff, 1.4, dealer);
}

void draw() {
  background(255);
  g.show(down);
  if (c != null) {
    int h = 0;
    if (g.currPlayer == 2) h = 400;
    c.show(width/2 + 70, height/2 - 260 + h, false);
  }
}

void mousePressed() {
  if (g.isOver()) {
    if (down) {
      down = false;
    } else {
      g.update();
      p.reset(g.allCards, g);
      down = true;
    }
  } else if (p.player == g.currPlayer) {
    println();
    p.makeMove();
  } else {
    if (!b) {
      c = g.getNextCard();
      b = true;
    } else if (b) {
      if (mouseX > 3 * width / 4) {
        if (g.addToCribb(c)) {
          p.updateCribb(new Card(14, 'f'));
          c = null;
          b = false;
        }
      } else {
        int r1 = (int)((mouseY-55)*5./(650));
        int c1 = (int)((mouseX-100)*5./(600));
        if (r1 >= 0 && r1 < 5 && c1 >= 0 && c1 < 5) {
          if (g.addToBoard(c, c1, r1)) {
            c = null;
            b = false;
            p.updatePlays(c);
          }
        }
      }
    }
  }
}
