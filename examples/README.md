# Interactions with the IG API

# Goal

Create an interactive application that can place trades on behalf of the user
given input in the form of a list of potential trades to take. Provide
notification of activity and a confirmation mechanism to allow the user to
manually intervene in the placing of trades.

# Problems

* Obtaining a logged in session from the API
* Placing a single trade
* Parsing, interpreting instructions of a list of potential trades
* Seeking confirmation from the user before placing trades
* Reacting to the receipt of an email (whose payload is the trading
instructions)
