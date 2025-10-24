//
//  game.swift
//  
//
//  Created by Andreas Grimm on 05.10.2025.
//
import Foundation

class Game {
    func game() {
        // Declare constants
        // Cities
        let city_list = ["Monterana", "Santa Paravia", "Fiumaccio", "Torricella", "Molinetto", "Fontanile", "Romanga" ];
        
        // Declare working variables
        // Players (0..6)
        var players = [Player]();
        
        // Empty screen and start game
        Common.clear();
        
        print("Santa Paravia and Fiumaccio\n\n");
        print("Do you wish instructions (Y or N)? ", terminator: "");
        
        let answer = Common.readString(default: "n", allowed: ["Y","y","N","n"]);
        if (answer == "y") || (answer == "Y") {
            self.rules();
        }
        
        print("How many people want to play (1 to 6)? ", terminator: "");
        let num_of_players: Int = Int(Common.readInt(lower: 0, upper: 6));
        
        if (num_of_players == 0) {
            print("Thanks for playing.\n");
            return
        }
        
        print("\nWhat will be the difficulty of this game:\n\n1. Apprentice");
        print("2. Journeyman\n3. Master\n4. Grand Master\n");
        print("Choose: ", terminator: "");
        
        let level = Common.readInt(lower: 1, upper: 4);
        
        // create the different players
        for counter in 1 ..< (num_of_players + 1) {
            
            // change the name of the city if desired
            print("Player \(counter), how do you want to name your country [\(city_list[counter])] ? ", terminator: "");
            var city_name = Common.readString();
            if city_name.count < 1 {
                city_name = city_list[Int(counter)];
            }
            
            // enter the play name
            print("Who is the ruler of \(city_name)? ", terminator: "");
            let player_name = Common.readString(mustNotBeEmpty: true);
            
            // answer on gender - yes, we understand this is not pc - and it might be changed. This is the
            // way the original game in the 70's was...
            print("\nIs \(player_name) a man or a woman (M or F)? ", terminator: "");
            let answer = Common.readString(allowed: ["F","m","f","M"]);
            let gender: Bool;
            if (answer == "f") || (answer == "F") {
                gender = false;
            } else {
                gender = true;
            }
            
            // create a new player and push it in the vector
            let player: Player = Player();
            player.createPlayer(playerName: player_name, playerGender: gender, cityName: city_name, difficulty: Int(level));
            
            players.insert(player, at: counter - 1);
            
            print("Thank you, \(player.get_title()) \(player.get_name()) of \(player.get_city())\n\n");
        }
        
        // Enter the main game loop.
        play_game(players: &players);
        
        // We're finished.
        return
    }
    

    /*
    Private function "Play Game"

    This function contains the main loop of the program.

    Within the main loop, the program loops through all players. If the player selected is alive then the
    next turn for the player is started. A dead player is skipped. If alive check also verifies that there
    is at least one living player, otherwise the program stops.

    The next check verifies that the current player has not yet won. This check ignores the living status
    of the player, so even a dead player wins if it has reached the winning level in the previous round
    (even at that stage the player should have already won)

    If all players are dead, means no player reached the winning level before they died, the games ends
    without a winner
     */
    func play_game(players: inout [Player]) {
        var all_dead: Bool = true;

        while true {
            for counter in 0 ..< (players.count) {
                var player = players[counter];
                if player.dead() == false {
                    new_turn(player: &player, players: &players);
                    all_dead = false;
                }

                if player.i_won == true {
                    print("Game Over. \(player.get_title()) \(player.get_name()) wins...");
                    return
                }
            }

            for player in players {
                player.consolidate();
            }

            if all_dead == true {
            print("The game has ended.\n");
            break;
            }
        }
    }



    /*
    Private function "New Turn"

    This function executes the different steps for a selected player.

    A turn for a player consists of a number of steps, each covering a different aspect of the year. The
    steps are implemented in functions that are called one-by-one:

    Step 1: Calculate the harvest and the grain prices. Some of the stored grain will be eaten by the local
            rats. No interaction for the player in this step.
    Step 2: Part (a): The player is able to buy and sell grain, and also to buy and sell land to save or
            gain additional finances for the round.
            Part (b): To feed the population and the military, the player can release some of the grain.
            The program demands a minimal amount of grain to be releases, but also caps the release to
            keep some stock for the player.
    Step 3: Verify the military defense capabilities. If the player's land is not protected enough, the
            player will be attacked and property will be taken.
     */
    func new_turn(player: inout Player, players: inout [Player]) {
        // Step 1: Calculate harvest and loss of grain due to rats
        player.harvest_land_and_grain_prices();
        player.rat_loss();

        // Step 2: Adjust grain and land and release food to people
        buy_and_sell_grain(player: &player);
        release_grain(player: &player);

        // Step 3: Verify military defense capabilities
        verify_defense(player: &player, players: &players);

        // Step 4: Generate income and adjust it
        generate_income(player: &player);

        // Step 5: Purchases
        make_purchases(player: &player, players: &players);

        // Step 6: check for the bankruptcy or end of life
        check_survival_or_win(player: &player);

        return;
    }



    /*
    Private function "Buy and Sell Grain"

    Step 2(a) in the game flow

    This function takes a player and returns the modified version of the player.

    This function presents the player with the harvest situation and allows the adjustment of the grain storage and the land size.
    To do this the player is able to
    - buy grain
    - sell grain
    - buy land, and
    - sell land

    Based on those numbers, the available stock of grain is adjusted, which is needed for the next step.
     */
    func buy_and_sell_grain(player: inout Player) {
        let harvest_rating = [
            "Drought. Famine Threatens. ",
            "Bad Weather. Poor Harvest. ",
            "Normal Weather. Average Harvest. ",
            "Good Weather. Fine Harvest. ",
            "Excellent Weather. Great Harvest! "];

        var finished: Bool = false;

        while finished == false {
            Common.clear();

            let year = player.get_year();
            let title = player.get_title();
            let name = player.get_name();
            let rats = player.get_rats();
            let rats_ate = player.get_rats_ate();
            let harvest_rating_value = player.get_harvest();
            let reserve = player.get_grain_reserve();
            let demand = player.get_grain_demand();
            let grain_price = player.get_grain_price();
            let land_price = player.get_land_price();
            let treasury = player.get_treasury();
            let land =  player.get_land();

            let harvest_rating_unwrapped = harvest_rating[Int(harvest_rating_value)];
            
            print(String(format: "\nYear %.0i", year));
            print("\n\(title) \(name)");
            print(String(format: "\nRats ate %i percent of your grain reserves (%.2f steres).", rats, rats_ate));
            print("\n\(harvest_rating_unwrapped)\n");
            print("\nGrain\t\tGrain\t\tPrice of\tPrice of\tTreasury");
            print("Reserve\t\tDemand\t\tGrain\t\tLand\n");
            print(String(format: "%7.2f\t%7.2f\t%7.2f\t\t%7i\t\t%7i\n", reserve, demand, grain_price, land_price, treasury));
            print("steres\t\tsteres\t\t1000 st.\thectare\t\tgold florins\n");
            print("\nYou have \(land) hectares of land.\n");
            print("\n1. Buy grain, 2. Sell grain, 3. Buy land, 4. Sell land ");

            print("(Enter q to continue):");

            let answer = readLine();

            if (answer == "q") || (answer == "Q") {
                finished = true;
            }

            if answer == "1" {
                print("\nHow much grain do you want to buy (0 to specify a total)? ", terminator: "");
                let amount = Float(Common.readFloat());

                if amount == 0.0 {
                    print("\nHow much total grain do you wish in your storage? ", terminator: "");
                    var amount = Float(Common.readFloat());
                    amount = amount - player.get_grain_reserve();
                }

                if amount < 0.0 {
                    print("Invalid total amount.");
                } else {
                    let ok = player.buy_grain(amount: amount);

                    if !ok {
                        print("\nYou cannot effort it. Transaction not executed.");
                    }
                }
            }

            if answer == "2" {
                print("\nHow much grain do you want to sell (0 to specify a total)? ", terminator: "");
                var amount = Float(Common.readFloat());

                if amount == 0.0 {
                    print("\nHow much total grain do you wish to possess? ", terminator: "");
                    amount = Float(Common.readFloat());
                    amount = amount - player.get_grain_reserve();
                }

                if amount < 0.0 {
                    print("Invalid total amount.\n");
                } else {
                    let ok = player.sell_grain(amount: amount);

                    if !ok {
                        print("\nYou don't have it. Transaction not executed.");
                    }
                }
            }

            if answer == "3" {
                print("\nHow much land do you want to buy (0 to specify a total)? ", terminator: "");
                var amount = Int(Common.readInt());

                if amount == 0 {
                    print("\nHow much total land do you wish? ", terminator: "");
                    amount = Int(Common.readInt());
                    amount = amount - player.get_land();
                }

                if amount < 0 {
                    print("Invalid total amount.\n");
                } else {
                    let ok = player.buy_land(amount: amount);

                    if !ok {
                        print("\nYou cannot effort it. Transaction not executed.");
                    }
                }
            }

            if answer == "4" {
                print("\nHow much land do you want to sell (0 to specify a total)? ", terminator: "");
                var amount = Int(Common.readInt());

                if amount == 0 {
                    print("\nHow much total land do you wish? ", terminator: "");
                    amount = Int(Common.readInt());
                    amount = player.get_land() - amount;
                }

                if amount < 0 {
                    print("Invalid total amount.\n");
                } else {
                    let ok = player.sell_land(amount: amount);

                    if !ok {
                        print("\nYou don't have it. Transaction not executed.");
                    }
                }
            }
        }

        return;
    }



    /*
    Private function "Release Grain"

    Step 2(b) in the game flow

    This function takes a player and returns the modified version of the player.

    This function allows the player to distribute grain to the population. Based on the release amount the
    local population will grow or shrink, a large donation of grain will attract outsiders into the country.

    There are limits on the amount of grain that the player can distribute: a minimum of 20% must be distributed,
    also 20% must remain in storage.
     */
    func release_grain(player: inout Player) {
        var ok: Bool = false;
        var amount: Float = 0.0;

        while ok == false {
            print("\nHow much grain will you release for consumption?");
            print(String(format:"1 = Minimum (%7.2f), 2 = Maximum(%7.2f), or enter a value: ",player.get_minimum_grain(), player.get_maximum_grain()), terminator: "");

            amount = Float(Common.readFloat(lower: Float(player.get_minimum_grain()), upper: Float(player.get_maximum_grain())));

            var too_little: Bool = false;
            var too_much: Bool = false;

            (too_little, too_much) = player.release_grain_check(released_grain: amount);

            // Are we being a Scrooge?
            if too_little {
                print("You must release at least 20% of your reserves.");
            } else if too_much {
                // Whoa. Slow down here son.
                print("You must keep at least 20%.");
            } else {
                ok = true;
            }
        }

        player.process_released_grain(released_grain: amount);

        // now let's check the results of our actions
        print(String(format: "\nYou have a total of %5i serfs in the city", player.get_serfs()));
        print(String(format: "\t%5i serfs were born this year", player.get_born_serfs()));
        print(String(format: "\t%5i serfs died this year", player.get_dead_serfs()));

        if player.get_immigrated_serfs() > 0 {
            print(String(format: "\t%5i serfs immigrated into your city", player.get_immigrated_serfs()));
        }

        if player.get_fleeing_serfs() > 0 {
            print(String(format: "\t%5i serfs flee harsh justice", player.get_immigrated_serfs()));
        }

        if player.get_market_revenue() > 0 {
            print(String(format: "\nYour markets made a win of %5i florint", player.get_market_revenue()));
        }

        if player.get_mill_revenue() > 0 {
            print(String(format: "Your mills made a win of %5i florint", player.get_mill_revenue()));
        }

        if player.get_soldier_pay() > 0 {
            print(String(format: "You paid your soldiers %5i florint", player.get_soldier_pay()));
        }

        print("(Press ENTER to continue)", terminator: "");
        var _ = readLine();
        Common.clear();

        return;
    }


    /*
    Private function "Verify Defense"

    Step 3 in the game flow

    This function takes a player and returns the modified version of the player.

    This function verifies the defense capabilities of the player and if the player is due for being
    attacked, the attacked is performed. The player is robbed by another player that is gaining a certain
    amount of the player's land. Also, a number of soldiers die, those are not moved into another player's
    property.

    Based on those numbers, the available stock of grain is adjusted, which is needed for the next step.
     */
    func verify_defense(player: inout Player,  players: inout [Player]) {

        var attacked : Bool = false;

        if player.get_invade_me() == true {
            Common.clear()

            var dead_soldiers : Int = 0;
            var land_taken : Int = 0;
            
            // let's see whether one of the other players is strong enough to attack
            for opponent in players {

                if attacked == false {
                    //I cannot attack myself
                    if opponent.get_name() != player.get_name() {
                        if opponent.get_soldiers() > player.get_soldiers() {
                            (land_taken, dead_soldiers) = player.attacked_by_neighbor(opponent: opponent);
                            opponent.gain_land(gained_land: land_taken);

                            attacked = true;
                        }
                    }
                }

                if attacked != true {
                    let evil_baron: Player = Player();
                    evil_baron.createPlayer(playerName: "Peppone", playerGender: true, cityName: "Monterana", difficulty: 0);
                    (land_taken, dead_soldiers) = player.attacked_by_neighbor(opponent: evil_baron);
                }

                print(String(format: "\n\n%S of %S invades and seizes %5i hectares of land!\n", opponent.get_title(), opponent.get_name(), opponent.get_city(), land_taken));
                print(String(format:"%S %S loses %5i soldiers in battle.\n", player.get_title(), player.get_name(), dead_soldiers));
            }
        }


        return;
    }


    /*
    Private function "Generate Income"

    Step 4 in the game flow

    This function takes a player and returns the modified version of the player.

    This function presents the player income from
    - Custom's Duty
    - Sales Tax
    - Income Tax, and
    - Legal income

    Based on those numbers, the player can adjust the numbers for the next round. Tax rates and legal income is cap-ed, so not all tax rates are allowed.
     */
    func generate_income(player: inout Player) {
        var revenues: Float;
        let justice_level = ["---","Very Fair","Moderate","Harsh","Outrageous"];

        revenues = player.generate_income();

        print(String(format: "State revenues {%7.2f} gold florins.\n", revenues));

        print("\nCustoms Duty\tSales Tax\tIncome Tax\tJustice\n");
        print(String(format:"%7.2f\t%7.2f\t%7.2f\t%7.2f (%@)\n",
                 player.get_customs_duty_revenue(),
                 player.get_sales_tax_revenue(),
                 player.get_income_tax_revenue(),
                 player.get_justice_revenue(),
                 justice_level[player.get_justice()]));

        print(String(format:"(%7.2f)\t(%7.2f)\t(%7.2f)",
                 player.get_customs_duty(),
                 player.get_sales_tax(),
                 player.get_income_tax()));

        // Step  5: Adjust taxes
        var answer = "x";

        while (answer != "q") && (answer != "Q") {
            print("\nEnter duty or tax to adjust");
            print("1. Customs Duty, 2. Sales Tax, 3. Wealth Tax, 4. Justice");
            print("Enter tax number for changes, q to continue: ");
            answer = readLine() ?? "q";

            // Adjust custom's duty
            if answer == "1" {
                print("New customs duty (0 to 100): ");
                var duty = Float(Common.readFloat(lower: 0.0, upper: 100.0));
                if duty > 100.0 {
                    duty = 100.0;
                } else if duty < 0.0 {
                    duty = 0.0;
                }
                player.set_customs_duty(duty: duty);

            } else if answer == "2" {
                // Adjust sales tax
                print("New sales tax (0 to 100): ");
                var duty = Float(Common.readFloat(lower: 0.0, upper: 100.0));
                if duty > 50.0 {
                    duty = 50.0
                } else if duty < 0.0 {
                    duty = 0.0;
                }
                player.set_sales_tax(duty: duty);

            } else if answer == "3" {
                // Adjust income tax
                print("New income tax (0 to 25): ");
                var duty = Float(Common.readFloat(lower: 0.0, upper: 25.0));
                if duty > 25.0 {
                    duty = 25.0
                } else if duty < 0.0 {
                    duty = 0.0;
                }
                player.set_income_tax(duty: duty);

            } else if answer == "4" {
                // Adjust justice behaviour
                print("Justice: 1. Very fair, 2. Moderate, 3. Harsh, 4. Outrageous: ");
                var duty = Int(Common.readInt(lower: 1, upper: 4));
                if duty > 4 {
                    duty = 4;
                }
                if duty < 1 {
                    duty = 1;
                }
                player.set_justice(duty: duty);
            }
        }

        player.adjust_tax();
    }


    /*
    Private function "Make Purchase"

    Step 5 in the game flow

    This function takes a player and returns the modified version of the player.

    This function allows the player to
    - buy a marketplace
    - buy a woolen mill
    - buy a part of the palace
    - buy a part of the cathedral
    - convert a number of serfs to soldiers

    Every purchase object returns value in the next round, except the soldiers, which do provide security to the player, but do cost money.
    As an extra function, the player can retrieve some intelligence on the remaining players.
    */
    func make_purchases(player: inout Player, players: inout [Player]) {
        var answer: String = "s";

        while (answer != "q") && (answer != "Q") {
            print(String(format:"\n\n%@ %@\nState purchases.\n", player.get_title(), player.get_name()));
            print(String(format:"1. Marketplace (%7i)\t\t\t\t1000 florins\n", player.get_market_places()));
            print(String(format:"2. Woolen mill (%7i)\t\t\t\t2000 florins\n", player.get_mills()));
            print(String(format:"3. Palace (partial) (%7i)\t\t\t\t3000 florins\n", player.get_palaces()));
            print(String(format:"4. Cathedral (partial) (%7i)\t\t\t5000 florins\n", player.get_cathedral()));
            print("5. Equip one platoon of serfs as soldiers\t500 florins\n");
            print(String(format:"\nYou have %7i gold florins.\n", player.get_treasury()));
            print("\nTo continue, enter q. To compare standings, enter 6: ");

            answer = readLine() ?? "q"

            if answer == "1" {
                player.buy_market();
            } else if answer == "2" {
                player.buy_mill();
            } else if answer == "3" {
                player.buy_palace();
            } else if answer == "4" {
                player.buy_cathedral();
            } else if answer == "5" {
                player.buy_soldiers();
            } else if answer == "6" {
                show_stats(players: players);
            }
        }

        return;
    }


    func show_stats(players: [Player]) {
        Common.clear();

        print("    Nobles\t   Soldiers\t    Clergy\t Merchants\t     Serfs\t      Land\t  Treasury\n");
        for player in players {
            print("\n\(player.get_title()) \(player.get_name())");
            print(String(format:"%7i\t%7i\t%7i\t%7i\t%7i\t%7i\t%7i\n",
                  player.get_nobles(),
                  player.get_soldiers(),
                  player.get_clergy(),
                  player.get_merchants(),
                  player.get_serfs(),
                  player.get_land(),
                  player.get_treasury()));
        }

        print("\n(Press ENTER): ");
        let _ = readLine();
    }


    /*
    Private function "Check Survival or Win"

    Step 6 in the game flow

    This function takes a player and returns the modified version of the player.

    This function completes the cycle by verifying that the player is neither bankrupt, in the year of his / her death, and
    that the player has not reached the winning state. In each of the cases, the game will be altered:

    - Bankruptcy: all but some essential assets will be seized and the player will only keep some base properties.
    - Death: If the player is in the year of death, the state of the player is changed to dead. The player will not continue playing
    - Win: The player is set to winner and the program will later announce him as winner.

    Based on those numbers, the available stock of grain is adjusted, which is needed for the next step.
     */
    func check_survival_or_win(player: inout Player) {
        if player.get_bankrupt() {
            print("\n \(player.get_title()) \(player.get_name()) is bankrupt\n");
            print("\nCreditors have seized much of your assets.");
            print("(Press ENTER): ");

            let _ :String? = readLine();
        }

        if player.get_year() == player.get_year_of_death() {
            player.set_dead();
        }

        let promoted: Bool = player.check_new_title();

        if promoted {
            print("\nCongratulations. Player \(player.get_name()) has been promoted to \(player.get_title()).\n");
        }

        if player.get_title_num() >= 7 {
            player.set_winner(winner: true);
        }

        player.set_next_year();

        return;
    }

    /*
    Private function "Rules"

    This function presents the rules of the game to the player.
    */
    private func rules() {
        print("Santa Paravia and Fiumaccio\n");
        print("You are the ruler of a 15th century Italian city state.\n");
        print("If you rule well, you will receive higher titles. The first player to become king or queen wins.\n");
        print("Life expectancy then was brief, so you may not live long enough to win.\n");
        print("The computer provide you with information about your state:\n");
        print("You gain wealth if you have enough land to give all your serfs space to raise crops. If you give them");
        print("enough crops they will grow in numbers and produce more grain. If you distribute less");
        print("grain, some of your people will starve, and you will have a high death rate. High taxes raise money, but slow down");
        print("economic growth.  The markets make you money, they attract merchants. Churches get you clergy and raise your reputation");
        print("But be aware: Your wealth might attract greedy neighbors to attack you...\n\n");
        print("(Press ENTER to begin game)");

        let _ :String? = readLine();
    }

}
