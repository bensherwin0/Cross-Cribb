class MonteCarlo {
  Game g;
  float c; //exploration param
  int player; // p1 or p2
  int MAXTIME;
  Deck d;
  Card[] cribb;

  public MonteCarlo(Game g, int m, float c, int p) {
    this.g = g;
    this.c = c;
    player = p;
    MAXTIME = m;
    d = new Deck(g.allCards);
    for(int i = 0; i < 5; i++) {
      for(int j = 0; j < 5; j++) {
         if(g.board[i][j] != null) d.deck.remove(g.board[i][j]);   
      }
    }
    cribb = new Card[5];
    for(int i = 0; i < 5; i++) cribb[i] = g.cribb[i];
  }

  float randomPlayout(Game g1) {
    g1.cribb = new Card[5];
    for(int i = 0; i < 5; i++) {
       g1.cribb[i] = cribb[i]; 
    }
    int index = g1.p1.size() + g1.p2.size();
    while (!g1.isOver()) {
      int move = g1.legalMoves.get((int)(Math.random() * g1.legalMoves.size()));
      Card c = g1.getNextCard();
      if (move == -1) g1.addToCribb(c);
      else g1.addToBoard(c, (move % 5), (move / 5));
    }
    for(int i = 0; i < 5; i++) {
       if(g1.cribb[i].rank == 14) {
          g1.cribb[i] =  g1.allCards.deck.get(index);
          index++;
       }
    }
    return evalFinishedGame(g1.roundScore());
  }

  void makeMove() {
    if (g.legalMoves.size() == 1) {
      if (g.legalMoves.get(0) == -1) g.addToCribb(g.getNextCard());
      else g.addToBoard(g.getNextCard(), g.legalMoves.get(0)%5, g.legalMoves.get(0)/5);
    } else {
      float[] movevals = new float[g.legalMoves.size()];
      int[] movechecked = new int[g.legalMoves.size()];
      int checked = 0;
      Card c = g.getNextCard();
      int t1 = millis();
      while (millis() - t1 < MAXTIME) {
        float max = -10000000;
        int index = -1;
        for (int i = 0; i < g.legalMoves.size(); i++) {
          float val = (float)((movevals[i] / (movechecked[i] + 1)) + this.c * Math.sqrt(Math.log(checked + 1) / (movechecked[i] + 1)));
          if (val > max) {
            max = val;
            index = i;
          }
        }
        Game g1 = new Game(g, d);
        int move = g.legalMoves.get(index); //println(move + " " + g.currPlayer);
        if (move == -1) {
          g1.addToCribb(new Card(c.rank, c.suit));
          updateCribb(new Card(c.rank, c.suit));
        }
        else g1.addToBoard(new Card(c.rank, c.suit), move%5, move/5);
        movevals[index] += sigma(randomPlayout(g1));
        movechecked[index]++;
        checked++;
        if(move == -1) undoCribb();
      }
      int max = -1;
      int index = -1;
      for (int i = 0; i < movechecked.length; i++) {
        //println(g.legalMoves.get(i) + ": " + movechecked[i] + " " + (movevals[i]/movechecked[i]));
        if (movechecked[i] > max) {
          max = movechecked[i];
          index = i;
        }
      }
      int move = g.legalMoves.get(index);
      println("EVAL: " + (movevals[index]/movechecked[index]));
      if (move == -1) {
        g.addToCribb(c);
        updateCribb(c);
      }
      else g.addToBoard(c, move%5, move/5);
      updatePlays(c);
    }
  }

  float evalFinishedGame(int roundscore) {
    int factor = 1;
    if (player == 2) factor = -1;
    return factor * roundscore;
  }
  float sigma(float a) {
    return 1. / (1 + exp(-1 * a));
  }
  
  void updatePlays(Card c) {
    d.deck.remove(c);   
  }
  
  void reset(Deck d, Game g1) {
    this.d = new Deck(d); 
    cribb = new Card[5];
    for(int i = 0; i < 5; i++) cribb[i] = g1.cribb[i];
  }
  
  void updateCribb(Card c) {
    int i = 1;
    while (cribb[i] != null) i++;
    cribb[i] = c; 
  }
  
  void undoCribb() {
    int i = 4;
    while (cribb[i] == null) i--;
    cribb[i] = null; 
  }
}
