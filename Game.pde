public class Game { //<>//
  Deck allCards;
  Deck p1; //vertical, starts as dealer
  Deck p2; //horizontal
  int currPlayer;
  Card[][] board; // column, row
  Card[] cribb;
  int dealer; //1 or 2 - dealer gets cribb
  int score1;
  int score2;
  int over; //0 in progress, 1 p1, 2 p1 winner
  int[] cribbPiece;
  ArrayList<Integer> legalMoves;


  public Game(Game g) {
    allCards = new Deck(g.allCards);
    allCards.shuffle();
    Deck temp = new Deck(allCards);
    p1 = new Deck();
    p2 = new Deck();
    while (p2.size() < g.p2.size()) {
      p2.add(temp.dealTop());
    }
    while (p1.size() < g.p1.size()) {
      p1.add(temp.dealTop());
    }
    currPlayer = g.currPlayer;
    dealer = g.dealer;
    board = new Card[5][5];
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 5; j++) {
        board[i][j] = g.board[i][j];
      }
    }
    cribb = new Card[5];
    for (int i = 0; i < 5; i++) {
      cribb[i] = g.cribb[i];
    }
    score1 = g.score1;
    score2 = g.score2;
    over = g.over;
    cribbPiece = new int[2];
    cribbPiece[0] = g.cribbPiece[0];
    cribbPiece[1] = g.cribbPiece[1];
    legalMoves = new ArrayList<Integer>();
    for (int i = 0; i<g.legalMoves.size(); i++) {
      legalMoves.add(g.legalMoves.get(i));
    }
  }
  public Game(Game g, Deck d) {
    allCards = new Deck(d);
    allCards.shuffle();
    Deck temp = new Deck(allCards);
    p1 = new Deck();
    p2 = new Deck();
    while (p2.size() < g.p2.size()) {
      p2.add(temp.dealTop());
    }
    while (p1.size() < g.p1.size()) {
      p1.add(temp.dealTop());
    }
    currPlayer = g.currPlayer;
    dealer = g.dealer;
    board = new Card[5][5];
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 5; j++) {
        board[i][j] = g.board[i][j];
      }
    }
    cribb = new Card[5];
    for (int i = 0; i < 5; i++) {
      cribb[i] = g.cribb[i];
    }
    score1 = g.score1;
    score2 = g.score2;
    over = g.over;
    cribbPiece = new int[2];
    cribbPiece[0] = g.cribbPiece[0];
    cribbPiece[1] = g.cribbPiece[1];
    legalMoves = new ArrayList<Integer>();
    for (int i = 0; i<g.legalMoves.size(); i++) {
      legalMoves.add(g.legalMoves.get(i));
    }
  }

  public Game(Deck d) {
    allCards = new Deck(d);
    allCards.shuffle();
    Deck temp = new Deck(allCards);
    p1 = new Deck();
    p2 = new Deck();
    while (p2.size() < 14) {
      p1.add(temp.dealTop());
      p2.add(temp.dealTop());
    }
    currPlayer = 1;
    dealer = 2;
    board = new Card[5][5];
    cribb = new Card[5];

    board[2][2] = temp.dealTop();
    cribb[0] = board[2][2];
    score1 = 0;
    score2 = 0;
    over = 0;
    cribbPiece = new int[2];
    legalMoves = new ArrayList<Integer>();
    legalMoves.add(-1);
    for (int i = 0; i<25; i++) {
      if (i != 12) legalMoves.add(i);
    }
  }

  boolean addToBoard(Card c, int col, int row) {
    if (board[col][row] != null) return false;
    else {
      board[col][row] = c;
      if ((currPlayer == 1 && p2.size() != 0) || (currPlayer == 2 && p1.size() != 0)) currPlayer = currPlayer % 2 + 1;
      legalMoves.remove((Object) (row * 5 + col));
      if (legalMoves.size() > 0) {
        if (cribbPiece[currPlayer - 1] == 2 && legalMoves.get(0) == -1) legalMoves.remove(0);
        if (cribbPiece[currPlayer - 1] != 2 && legalMoves.get(0) != -1) legalMoves.add(0, -1);
      } else if (legalMoves.size() == 0) {
        if (cribbPiece[currPlayer - 1] != 2) legalMoves.add(0, -1);
      }

      return true;
    }
  }

  boolean addToCribb(Card c) {
    if (cribbPiece[currPlayer - 1] == 2) return false;
    int i = 1;
    while (cribb[i] != null) i++;
    cribb[i] = c;
    if (currPlayer == 1) {
      cribbPiece[0]++;
      if (cribbPiece[0] == 2) legalMoves.remove(0);
      if (p1.isEmpty()) {
        currPlayer = currPlayer % 2 + 1;
        if (cribbPiece[currPlayer - 1] != 2) legalMoves.add(0, -1);
      }
    } else if (currPlayer == 2) {
      cribbPiece[1]++;
      if (cribbPiece[1] == 2) legalMoves.remove(0);
      if (p2.isEmpty()) {
        currPlayer = currPlayer % 2 + 1;
        if (cribbPiece[currPlayer - 1] != 2) legalMoves.add(0, -1);
      }
    }
    return true;
  }

  boolean isOver() {
    if (!p1.isEmpty() || !p2.isEmpty()) return false;
    else {
      if (cribb[4] == null) return false;
      for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 5; j++) {
          if (board[i][j] == null) return false;
        }
      }
      return true;
    }
  }

  int scoreGroup(Card[] group, boolean isCrib) { //5 cards long
    int score = 0;
    List<Card> g = new ArrayList<Card> (Arrays.asList(group));
    Collections.sort(g);

    //flush
    char firstSuit = g.get(0).suit;
    char secondSuit = g.get(1).suit;
    int flush1 = 0;
    int flush2 = 0;
    for (int i = 0; i<5; i++) {
      if (g.get(i).suit == firstSuit) flush1++;
      if (g.get(i).suit == secondSuit) flush2++;
    }

    if (flush1 == 5) score += flush1;  
    else if (flush1 == 4 && !isCrib) score += flush1;      
    else if (flush2 == 4 && !isCrib) score += flush2;

    //sum to 15
    for (int i = 0; i < 4; i++) {
      Card c = g.get(i);
      for (int j = i + 1; j < 5; j++) {
        Card d = g.get(j);
        if (c.value + d.value == 15) score += 2;
      }
    }
    //sum to 15 of 3, 4, or 5 cards
    int sum = 0;
    for (int i = 0; i < 5; i++) sum += g.get(i).value;
    if (sum == 15) score += 2;
    else if (sum > 15) {
      for (int i = 0; i < 5; i++) {
        if (sum - g.get(i).value == 15) score += 2;
      }
      for (int i = 0; i < 4; i++) {
        Card c = g.get(i);
        for (int j = i + 1; j < 5; j++) {
          Card d = g.get(j);
          int s = sum - c.value - d.value;
          if (s == 15) score += 2;
        }
      }
    }

    //runs and pairs
    ArrayList<Integer> counts = new ArrayList<Integer>();
    for (int i = 0; i < g.size(); i++) {
      counts.add(1);
      int j = i+1;
      while (j < g.size() && g.get(j).rank == g.get(i).rank) {
        g.remove(j);
        counts.set(i, counts.get(i) + 1);
      }
    }

    for (Integer i : counts) {
      if (i != 1) {
        if (i == 2) score += 2;
        else if (i == 3) score += 6;
        else if (i == 4) score += 12;
      }
    }
    int runcounter = 0;
    int endi = 0;
    for (int i = 0; i<g.size() - 1; i++) {
      if (g.get(i).rank == g.get(i + 1).rank - 1) {
        runcounter++;
        if (runcounter > 1) endi = i + 1;
      } else if (runcounter < 2) runcounter = 0;
      else break;
    }
    if (runcounter > 1) {  
      int counter = runcounter;    
      int doubles = 1;
      while (counter >= 0) {
        if (counts.get(endi) == 2) doubles++;
        if (counts.get(endi) == 3) doubles += 2;
        counter--;
        endi--;
      }
      int adder = runcounter + 1;
      adder = adder * doubles;
      score = score + adder;
    }
    //run with aces as 14
    if (g.get(0).rank == 1 && g.get(g.size() - 1).rank == 13) {
      int kingcounter = 0;
      int queencounter = 0;
      int jackcounter = 0;
      int tencounter = 0;
      int acecounter = 0;
      for (int fuck = 0; fuck < g.size(); fuck++) {
        if (g.get(fuck).rank == 13) kingcounter++;
        if (g.get(fuck).rank == 12) queencounter++;
        if (g.get(fuck).rank == 11) jackcounter++;
        if (g.get(fuck).rank == 10) tencounter++;
        if (g.get(fuck).rank == 1) acecounter++;
      }
      if (queencounter > 0) {
        int adder = 3;
        if (jackcounter > 0) adder = adder + jackcounter + tencounter;
        adder = adder * kingcounter * queencounter * acecounter;
        if(jackcounter > 0) adder *= jackcounter;
        score = score + adder;
      }
    }
    return score;
  }

  int roundScore() { // player 1 is verticle and positive, player 2 is horizontle and negative
    int vscore = 0;
    for (int i = 0; i < 5; i++) {
      Card[] slice = new Card[5];
      for (int j = 0; j < 5; j++) {
        slice[j] = board[i][j];
      }
      vscore += scoreGroup(slice, false);
    }  

    int hscore = 0;
    for (int i = 0; i<5; i++) {
      Card[] slice = new Card[5];
      for (int j = 0; j<5; j++) {
        slice[j] = board[j][i];
      }
      hscore += scoreGroup(slice, false);
    }  
    if (dealer == 1) vscore += scoreGroup(cribb, true);
    else hscore += scoreGroup(cribb, true);

    return vscore - hscore;
  }

  Card getNextCard() {
    if (currPlayer == 1) return p1.dealTop();
    else return p2.dealTop();
  }



  void update() {
    if (isOver()) {
      int s = roundScore();
      if (s > 0) score1 += s;
      else score2 -= s;

      allCards.shuffle();
      Deck temp = new Deck(allCards);
      p1 = new Deck();
      p2 = new Deck();
      while (p2.size() < 14) {
        p1.add(temp.dealTop());
        p2.add(temp.dealTop());
      }
      currPlayer = dealer;
      dealer = dealer % 2 + 1;
      board = new Card[5][5];
      cribb = new Card[5];

      board[2][2] = temp.dealTop();
      cribb[0] = board[2][2];
      cribbPiece = new int[2];
      legalMoves = new ArrayList<Integer>();
      legalMoves.add(-1);
      for (int i = 0; i<25; i++) {
        if (i != 12) legalMoves.add(i);
      }

      if (score1 >= 31) over = 1;
      else if (score2 >= 31) over = 2;
    }
  }

  void show(boolean c) {
    stroke(0);
    strokeWeight(3);
    for (int i = 0; i < 6; i++) {
      line(100, 55 + 130*i, 700, 55 + 130*i);
      line(100 + 120*i, 55, 100 + 120*i, 705);
    }
    line(1100, 55, 1100, 705);
    line(1220, 55, 1220, 705);
    for (int i = 0; i < 6; i++) {
      line(1100, 55 + 130*i, 1220, 55 + 130*i);
    }
    p1.show(800, 50);
    p2.show(800, 600);
    if (dealer == 1) {
      fill(255, 0, 0);
      circle(910, 75, 30);
    } else {
      fill(255, 0, 0);
      circle(910, 675, 30);
    }

    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 5; j++) {
        if (board[i][j] != null)
          board[i][j].show(110 + 120*i, 60 + 130*j, false);
      }
    }
    cribb[0].show(1110, 60, false);
    for (int i = 1; i < 5; i++) {
      if (cribb[i] != null)
        cribb[i].show(1110, 60 + 130*i, c);
    }

    textSize(32);
    fill(0);
    text("P1 SCORE: " + score1, 900, 30, 300, 60);
    text("P2 SCORE: " + score2, 900, 700, 300, 60);
  }
}
