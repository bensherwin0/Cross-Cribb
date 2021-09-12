# Cross-Cribb
An implementation of the game of Cross Cribbage, along with a strong computer opponent. Created in Processing.

Play CrossCribb against a computer!  
# HOW TO PLAY:
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
  
# DESCRIPTION:
  The computer uses probabilistic Monte Carlo Tree search to analyze how
  good each availible move is.  It plays each move, and simulates many different
  possible games.  The move that led to the most won games is chosen.  Since
  the computer does not know the order of the rest of the cards, or the contents
  of what the opponent put into the cribb, it guesses based on what cards are
  still availible.
