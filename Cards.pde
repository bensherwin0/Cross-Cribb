class Card implements Comparable<Card>{
  int rank; //1 - 13
  char suit; //c, h, d, s
  int value; // 1- 10

  public Card(int rank, char suit) {
    this.rank = rank;
    this.suit = suit;
    value = rank;
    if (rank > 10) value = 10;
  }

  String toString() {
    String s = "";
    if (rank == 11) s = "J";
    else if (rank == 12) s = "Q";
    else if (rank == 13) s = "K";
    else if (rank == 1) s = "A";   
    else s = s + rank;
    s += " of ";     
    if (suit == 'c') s += "Clubs";
    if (suit == 'h') s += "Hearts";
    if (suit == 'd') s += "Diamonds";
    if (suit == 's') s += "Spades";     
    return s;
  }
  
  int compareTo(Card b) {
    return rank - b.rank;
  }
  
  void show(int x, int y, boolean b) {
     PImage img;
     if(b) img = back;
     else {
       int s = 0;
       if(suit == 'd') s = 1;
       else if(suit == 'h') s = 2;
       else if(suit == 's') s = 3;
       img = images[rank-1][s];
     }
     image(img, x, y, 100, 120);
  }
}

class Deck {
  private ArrayList<Card> deck;

  public Deck() {
    deck = new ArrayList<Card>();
  }

  public Deck(ArrayList<Card> d) {
    deck = new ArrayList<Card>(d);
  }

  // Shuffling the new deck prevents any cheating:
  //   any time anybody copies the game deck, it is out of order.
  public Deck(Deck d) {   
    deck = new ArrayList<Card>(d.deck);
    shuffle();
  }

  void shuffle() {
    Collections.shuffle(deck);
  }

  boolean add(Card c) {
    if (c != null) {
      deck.add(c);
      return true;
    } else return false;
  }

  Card dealTop() {
    if(deck.size() > 0)
      return deck.remove(0);
    else return null;
  }

  boolean isEmpty() {
    return deck.size() == 0;
  }

  int size() {
    return deck.size();
  }

  String toString() {
    String s = "[ ";
    for (Card c : deck) {
      s = s + c.toString() +", ";
    }
    s = s.substring(0, s.length() - 2) + " ]";
    return s;
  }
  
  void show(int x, int y) {
    image(back, x, y, 100, 120);
    textSize(50);
    fill(0);
    text("" + deck.size(), x+18, y+45, 100, 120);
  }
}
