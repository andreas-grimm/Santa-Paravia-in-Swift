//
//  player.swift
//  
//
//  Created by Andreas Grimm on 05.10.2025.
//
class Player {
    var cathedral: Int
    var clergy: Int
    var customs_duty: Float
    var customs_duty_revenue: Float
    var dead_serfs: Int
    var difficulty: Int
    var fleeing_serfs: Int
    var grain_demand: Float
    var grain_price: Float
    var grain_reserve: Float
    var harvest: Int
    var income_tax: Float
    var income_tax_revenue: Float
    var rats_ate: Float
    var justice: Int
    var justice_revenue: Float
    var land: Int
    var land_gained_from_attacks: Int
    var market_places: Int
    var market_revenue: Int
    var merchants: Int
    var mills_revenue: Int
    var mills: Int
    var new_serfs: Int
    var nobles: Int
    var old_title: Int
    var palace: Int
    var rats: Int
    var sales_tax: Float
    var sales_tax_revenue: Float
    var serfs: Int
    var soldiers_pay: Int
    var soldiers: Int
    var title_num: Int
    var transplanted_serfs: Int
    var treasury: Int
    var year: Int
    var year_of_death: Int
    /* String variable parts */
    var city :String
    var name: String
    var title: Int
    /* Float variable parts */
    var public_works: Float
    var land_price: Int
    /* boolean variable parts */
    var invade_me: Bool
    var is_bankrupt: Bool
    var is_dead: Bool
    var i_won: Bool
    var male: Bool
    
    init() {
        self.cathedral = 0
        self.clergy = 5
        self.customs_duty = 25
        self.customs_duty_revenue = 0
        self.dead_serfs = 0
        self.difficulty = 1
        self.fleeing_serfs = 0
        self.grain_demand = 0
        self.grain_price = 25
        self.grain_reserve = 5000
        self.harvest = 0
        self.income_tax = 5
        self.income_tax_revenue = 0
        self.rats_ate = 0
        self.justice = 2
        self.justice_revenue = 0
        self.land = 10000
        self.land_gained_from_attacks = 0
        self.market_places = 0
        self.market_revenue = 0
        self.merchants = 25
        self.mills_revenue = 0
        self.mills = 0
        self.new_serfs = 0
        self.nobles = 4
        self.old_title = 0
        self.palace = 0
        self.rats = 0
        self.sales_tax = 10
        self.sales_tax_revenue = 0
        self.serfs = 2000
        self.soldiers_pay = 0
        self.soldiers = 25
        self.title_num = 0
        self.transplanted_serfs = 0
        self.treasury = 1000
        self.year = 1400
        self.year_of_death = 0
        self.city = ""
        self.name = ""
        self.title = 0
        self.public_works = 0
        self.land_price = 0
        self.invade_me = false
        self.is_bankrupt = false
        self.is_dead = false
        self.i_won = false
        self.male = true
    }
    
    func createPlayer(playerName: String, playerGender: Bool, cityName: String, difficulty: Int) {
        self.city = cityName;
        self.name = playerName;
        self.male = playerGender;
        self.difficulty = difficulty;
        
        return;
    }
    
    // String variable parts
    
    func set_customs_duty(duty: Float) {
        self.customs_duty = duty;
        
        return;
    }
    
    func set_sales_tax(duty: Float) {
        self.sales_tax = duty;
        
        return;
    }
    
    func set_income_tax(duty: Float) {
        self.income_tax = duty;
        
        return;
    }
    
    func set_justice(duty: Int) {
        self.justice = duty;
        
        return;
    }
    
    func set_dead() {
        self.is_dead = true;
        
        return;
    }
    
    func set_next_year() {
        self.year = self.year + 1;
        
        return;
    }

    func set_winner(winner: Bool) {
        self.i_won = winner;
        
        return;
    }

    private func add_revenue() {
        self.treasury = self.treasury + Int(self.justice_revenue) + Int(self.customs_duty_revenue);
        self.treasury = self.treasury + Int(self.income_tax_revenue) + Int(self.sales_tax_revenue);

        if self.treasury < 0 {
            self.treasury = Int(Double(self.treasury) * 1.5);
        }

        if self.treasury < -10000 * Int(self.title) {
           self.is_bankrupt = true;
        }

        return;
    }

    func adjust_tax() {
        self.add_revenue();

        if self.is_bankrupt == true {
        //    self.seize_assets();
        }

        return;
    }

    func attacked_by_neighbor(opponent:Player) -> (Int, Int) {
        var land_taken: Int = (self.soldiers * 1000) - (self.land / 3);

        if land_taken > (self.land - 5000) {
            land_taken = (self.land - 5000) / 2
        }

        self.land -= land_taken;

        var dead_soldiers: Int = Int.random(in: 0 ..< 40);

        if dead_soldiers > (self.soldiers - 15) {
            dead_soldiers = self.soldiers - 15;
        }

        self.soldiers -= dead_soldiers;

        return (land_taken, dead_soldiers);
    }

    func buy_cathedral() {
        self.cathedral += 1;
        self.clergy += Int.random(in: 0 ... 6);
        self.treasury = self.treasury - 5000;
        self.public_works += 1.0;

        return;
    }

    func buy_grain(amount: Float) -> Bool {
        let cost = amount * self.grain_price / 1000.0;
        if cost > Float(self.treasury) {
           return (false);
        }
        
        self.treasury = self.treasury - Int(cost);
        self.grain_reserve += amount;

        return (true);
    }


    func buy_land(amount: Int) -> Bool {
        let cost = amount * self.land_price;
        if cost > self.treasury {
            return (false);
        }

        self.land += amount;
        self.treasury = self.treasury - (amount * self.land_price);

        return (true);
    }

    func buy_market() {
        self.market_places += 1;
        self.merchants += 5;
        self.treasury = self.treasury - 1000;
        self.public_works += 1.0;

        return;
    }

    func buy_mill() {
        self.mills += 1;
        self.treasury = self.treasury - 2000;
        self.public_works += 0.25;

        return;
    }

    func buy_palace() {
        self.palace = self.palace + 1;
        self.nobles = self.nobles + Int.random(in: 0 ... 2);
        self.treasury = self.treasury - 3000;
        self.public_works = self.public_works + 0.5;

        return;
    }

    func buy_soldiers() {
        self.soldiers = self.soldiers + 20;
        self.serfs = self.serfs - 20;
        self.treasury = self.treasury - 500;

        return;
    }

    func check_new_title() -> Bool {

        var total: Int = Common.limit10(number:self.market_places, denomination:1);
        total += Common.limit10(number:self.palace, denomination:1);
        total += Common.limit10(number:self.cathedral, denomination:1);
        total += Common.limit10(number:self.mills, denomination:1);
        total += Common.limit10(number:self.treasury, denomination:5000);
        total += Common.limit10(number:self.land, denomination:6000);
        total += Common.limit10(number:self.merchants, denomination:50);
        total += Common.limit10(number:self.nobles, denomination:5);
        total += Common.limit10(number:self.soldiers, denomination:50);
        total += Common.limit10(number:self.clergy, denomination:10);
        total += Common.limit10(number:self.serfs, denomination:2000);
        total += Common.limit10(number:Int(self.public_works * 100.0), denomination:500);

        self.title = total / self.difficulty - self.justice;

        if self.title > 7 {
            self.title = 7;
        }

        if self.title > self.old_title {
            self.title = self.old_title + 1;
            self.old_title = self.title;

            if self.title >= 7 {
                self.i_won = true;
            }

            return (true);
        }

        self.title = self.old_title;
        return (false);
    }

    func generate_income() -> Float {
        self.justice_revenue = (Float(self.justice) * 300.0 - 500.0) * Float(self.title);

        var revenue_base: Float = 150.0 - (self.sales_tax - self.customs_duty - self.income_tax);

        if revenue_base < 1.0 {
            revenue_base = 1.0;
        }

        revenue_base = revenue_base / 100.0;

        self.customs_duty_revenue = Float((Float(self.nobles * 180) + Float(self.clergy * 75) + Float(self.merchants * 20)) * revenue_base) ;
        self.customs_duty_revenue = self.customs_duty_revenue + (self.public_works) * 100.0;
        self.customs_duty_revenue = self.customs_duty / 100.0 * self.customs_duty_revenue;

        self.sales_tax_revenue = Float(self.nobles * 50) + Float(self.merchants * 25) + Float(self.public_works * 10.0);
        self.sales_tax_revenue = self.sales_tax_revenue * Float(revenue_base * (5.0 - Float(self.justice)) * self.sales_tax);
        self.sales_tax_revenue = self.sales_tax_revenue / 200.0;

        self.income_tax_revenue = Float(self.nobles * 250) + self.public_works * 20.0;
        self.income_tax_revenue = self.income_tax_revenue + Float(10 * Int(self.justice) * self.nobles) * revenue_base;
        self.income_tax_revenue = self.income_tax_revenue * self.income_tax;
        self.income_tax_revenue = self.income_tax_revenue / 100.0;

        let revenues: Float = self.customs_duty_revenue + self.sales_tax_revenue + self.income_tax_revenue + self.justice_revenue;

        return (revenues);
    }

    func dead() -> Bool {
        return self.is_dead;
    }

    /*
    Function to store land gained from attacks.
    */
    func gain_land(gained_land: Int) {
        self.land_gained_from_attacks = self.land_gained_from_attacks + gained_land;
        return;
    }

    func harvest_land_and_grain_prices() {
        self.harvest = (Int.random(in: 0...5) + Int.random(in: 0 ... 6)) / 2;

        if self.harvest > 5 {
            self.harvest = 5;
        } else if self.harvest < 1 {
            self.harvest = 1;
        }

        // Generate an offset for use in later int -> float conversions.
        // we are using 8-bit random numbers
        let my_random: Float = Float.random(in: 0 ... 32768) / 32768.0;

        // If you think this Rust code is ugly, you should see the original BASIC.
        var worked_land: Float = Float(self.land);

        // available work force = number of serfs - number of serfs needed for mills (1 serf per mill) times 100
        let available_work_force: Float = Float((self.serfs - self.mills) * 100);

        // every unit available work force can work on 5 ha of land
        var processable_land: Float = Float(available_work_force) * 5.0;

        if processable_land < 0.0 {
            processable_land = 0.0;
        }

        if processable_land < worked_land {
            worked_land = processable_land;
        }

        // to grow grain, 2 units of grain are needed per ha of land
        let max_land_to_be_used_due_to_grain:Float = self.grain_reserve * 2.0;

        if max_land_to_be_used_due_to_grain < worked_land {
            worked_land = max_land_to_be_used_due_to_grain;
        }

        let harvest_per_ha:Float = Float(self.harvest) + my_random - 0.5;

        var harvest = harvest_per_ha * worked_land;

        self.grain_reserve = self.grain_reserve + harvest;

        // calculating grain demand
        self.grain_demand = Float((self.nobles * 100) + (self.cathedral * 40) + (self.merchants * 30) + (self.soldiers * 10) + (self.serfs * 5));

        // calculating land price
        self.land_price = (3 * Int(self.harvest) + Int.random(in: 0 ... 6) + 10) / 10;

        if harvest < 0.0 {
            harvest = harvest * -1.0;
        }

        var grain_demand_coverage: Float;
        
        if harvest < 1.0 {
            grain_demand_coverage = 2.0
        } else {
            grain_demand_coverage = self.grain_demand / harvest;
        }

        if grain_demand_coverage > 2.0 {
            grain_demand_coverage = 2.0;
        }

        if grain_demand_coverage < 0.8 {
            grain_demand_coverage = 0.8;
        }

        self.land_price = self.land_price * Int(grain_demand_coverage);

        if self.land_price < 1 {
            self.land_price = 1;
        }

        self.grain_price = 6.0 - Float(self.harvest) * 3.0 + Float.random(in: 0 ... 5) + Float.random(in: 0 ... 5) * 4.0 * grain_demand_coverage;

        if self.grain_price < 0.0 {
            self.grain_price = 0.1;
        }

        return;
    }

    func process_released_grain(released_grain: Float) {
        self.soldiers_pay = 0;
        self.market_revenue = 0;
        self.new_serfs = 0;
        self.dead_serfs = 0;
        self.transplanted_serfs = 0;
        self.fleeing_serfs = 0;

        self.invade_me = false;
        
        var released_grain :Float = released_grain;

        if released_grain == 1.0 {
            released_grain = get_minimum_grain();
        }

        if released_grain == 2.0 {
            released_grain = get_maximum_grain();
        }

        self.grain_reserve = self.grain_reserve - released_grain;

        var demand_satisfaction = released_grain / (self.grain_demand - 1.0);

        if demand_satisfaction > 0.0 {
            demand_satisfaction = demand_satisfaction / 2.0;
        }

        if demand_satisfaction > 0.25 {
            demand_satisfaction = demand_satisfaction / 10.0 + 0.25;
        }

        // calculate current taxation level as 50% - all taxes
        var happiness_factor: Float = 50.0 - self.customs_duty - self.sales_tax - self.income_tax;

        // if all taxes exceed the 50%, multiply the number by the justice value
        if happiness_factor < 0.0 {
            happiness_factor = happiness_factor * Float(self.justice);
            // the harsher the justice, the more unhappy the people are
        }

        happiness_factor = happiness_factor / 10.0;

        // if the people are positive about their situation
        if happiness_factor > 0.0 {
            //decrement the value due to the justice
            happiness_factor = happiness_factor + 3.0 - Float(self.justice);
        }

        demand_satisfaction = demand_satisfaction + (happiness_factor / 10.0);

        if demand_satisfaction > 0.5 {
            // if the demand satisfaction exceeds .5, the cap it.
            demand_satisfaction = 0.5
        }

        let grain_demand = self.grain_demand;
        var grain_deficit: Float = 0.0;
        if released_grain < (grain_demand - 1.0) {
            grain_deficit = (grain_demand - released_grain) / (grain_demand * 100.0 - 9.0);

            var unhappiness_factor: Float = grain_deficit;

            if grain_deficit > 65.0 {
                grain_deficit = 65.0
            }

            if grain_deficit < 0.0 {
                unhappiness_factor = 0.0;
            }

            serfs_procreating(procreation_base: 3.0);
            serfs_decomposing(decomposing_base: unhappiness_factor + 8.0);
        } else {
            serfs_procreating(procreation_base: (7.0 * demand_satisfaction));
            serfs_decomposing(decomposing_base: 3.0);

            if (self.customs_duty + self.sales_tax) < 35.0 {
                // if customs duty and sales tax combined are less than 35%
                self.merchants += Int.random(in: 0 ... 4);
            }

            if self.income_tax < Float.random(in: 0 ... 28) {
                self.nobles += Int.random(in: 0 ... 2);
                self.clergy += Int.random(in: 0 ... 3);
            }

            // overachieving annual results: 30% extra released
            if released_grain > self.grain_demand * 1.3 {
                let population_density = Float(self.serfs) / 1000.0;
                let transplanting_serfs: Int = (
                    Int(released_grain - (self.grain_demand)) /
                    Int(self.grain_demand * 10.0) *
                    Int(population_density) *
                    Int.random(in: 0 ... 25) +
                    Int.random(in: 0 ... 40));
                
                self.transplanted_serfs = transplanting_serfs;
                self.serfs = self.serfs + self.transplanted_serfs;

                var immigration_pull: Int = transplanting_serfs;
                immigration_pull = immigration_pull * Int.random(in: 0 ... 100) / 100;

                if immigration_pull > 50 {
                    immigration_pull = 50;
                }

                self.merchants = self.merchants + immigration_pull;
                self.nobles = self.nobles + 1;
                self.clergy = self.clergy + 2;
            }
        }

        if self.justice > 2 {
            self.justice_revenue = Float(self.serfs) / 100.0 * Float(self.justice - 2) * Float(self.justice - 2);
            self.justice_revenue = Float.random(in: 0 ... (self.justice_revenue));
            self.serfs = self.serfs - Int(self.justice_revenue);
            self.fleeing_serfs = Int(self.justice_revenue);
        }

        self.market_revenue = self.market_places * 75;

        if self.market_revenue > 0 {
            self.treasury = self.treasury + self.market_revenue;
        }

        self.mills_revenue = self.mills * (55 + Int.random(in: 0 ... 250));

        if self.mills_revenue > 0 {
            self.treasury = self.treasury + self.mills_revenue;
        }

        self.soldiers_pay = self.soldiers * 3;
        self.treasury = self.treasury - self.soldiers;

        if (self.land / 1000) > self.soldiers {
            self.invade_me = false;
        }

        if (self.land / 500) > self.soldiers {
            self.invade_me = true;
        }

        return;
    }

    func rat_loss() {
        self.rats = Int.random(in: 0 ... 50);
        self.rats_ate = self.grain_reserve * Float(self.rats) / 100.0;
        self.grain_reserve = self.grain_reserve - (self.rats_ate);

        return;
    }

    func release_grain_check(released_grain: Float) -> (Bool, Bool) {
        var too_little: Bool = false;
        var too_much: Bool = false;

        var released_grain: Float = released_grain;
        
        if released_grain == 1.0 {
            released_grain = get_minimum_grain();
        }

        if released_grain == 2.0 {
            released_grain = get_maximum_grain();
        }

        if (released_grain + 1.0) < get_minimum_grain() {
            // Are we being a Scrooge?
            too_little = true;
        } else if (released_grain - 1.0) > get_maximum_grain() {
            too_much = true;
        }

        return(too_little, too_much);
    }

    // seizing assets from a bankrupt player.
    private func seize_assets() {
        self.market_places = 0;
        self.palace = 0;
        self.cathedral = 0;
        self.mills = 0;
        self.land = 6000;
        self.public_works = 1.0;
        self.treasury = 100;
        self.is_bankrupt = true;

        return;
    }

    func sell_grain(amount: Float) -> Bool {
        if amount > self.grain_reserve {
            return (false);
        }

        self.treasury = self.treasury + Int(amount * self.grain_price / 1000.0);
        self.grain_reserve = self.grain_reserve - amount;

        return (true);
    }


    func sell_land(amount: Int) -> Bool {
        if amount > (self.land - 5000) {
            return (false);
        }

        self.land = self.land - amount;
        self.treasury = self.treasury + Int(amount * self.land_price);

        return (true);
    }

    func serfs_decomposing(decomposing_base: Float) {
        // split decomposingBase into the part before and after the decimal
        let decomposing_rate: Int = Int(decomposing_base);
        let overkill: Float = decomposing_base - Float(decomposing_rate);

        self.dead_serfs = Int.random(in: 0 ... (decomposing_rate + Int(overkill)) * (self.serfs)) / 100;
        self.serfs = self.serfs - self.dead_serfs;

        return;
    }

    func serfs_procreating(procreation_base: Float) {
        // split procreationBase into the part before and after the decimal
        let procreation_rate: Int = Int(procreation_base);
        let birth_surplus: Float = procreation_base - Float(procreation_rate);

        self.new_serfs = Int.random(in: 0 ...  (procreation_rate + Int(birth_surplus)) * (self.serfs)) / 100;
        self.serfs = self.serfs + self.new_serfs;

        return;
    }

    //
    // list of all getters for the class
    //
    func get_cathedral() -> Int {
        return self.cathedral;
    }

    func get_maximum_grain() -> Float {
        return self.grain_reserve - get_minimum_grain();
    }

    func get_minimum_grain() -> Float {
        return self.grain_reserve / 5.0;
    }

    func get_title() -> String {
        let male_titles: [String] = ["Sir", "Baron", "Count", "Marquis", "Duke", "Grand Duke", "Prince", "* H.R.H. King"];
        let female_titles: [String] = ["Lady", "Baroness", "Countess", "Marquise", "Duchess", "Grand Duchess", "Princess", "* H.R.H. Queen"];

        if self.title > 7 {
            self.title = 7;
        }

        var title :String;

        if self.male == true {
            title = male_titles[Int(self.title)];
        } else {
            title = female_titles[Int(self.title)];
        }

        return title;
    }

    /**
    Consolidate the gained land:
    */
    func consolidate() {
        self.land = self.land + self.land_gained_from_attacks;
        self.land_gained_from_attacks = 0;
        return;
    }

    func get_title_num() -> Int {
        return (self.title_num);
    }

    func get_name() -> String {
        return (self.name);
    }

    func get_city() -> String {
        return (self.city);
    }

    func get_year() -> Int {
        return (self.year);
    }

    func did_i_win() -> Bool {
        return (self.i_won);
    }

    func get_nobles() -> Int {
        return (self.nobles);
    }

    func get_clergy() -> Int {
        return (self.clergy);
    }

    func get_merchants() -> Int {
        return (self.merchants);
    }

    func get_rats() -> Int {
        return (self.rats);
    }

    func get_rats_ate() -> Float {
        return (self.rats_ate);
    }

    func get_harvest() -> Int {
        return (self.harvest - 1);
    }

    func get_grain_reserve() -> Float {
        return (self.grain_reserve);
    }

    func get_grain_demand() -> Float {
        return (self.grain_demand);
    }

    func get_grain_price() -> Float {
        return (self.grain_price);
    }

    func get_land() -> Int {
        return (self.land);
    }

    func get_land_price() -> Int {
        return (self.land_price);
    }

    func get_palaces() -> Int {
        return (self.palace);
    }

    func get_treasury() -> Int {
        return (self.treasury);
    }

    func get_serfs() -> Int {
        return (self.serfs);
    }

    func get_born_serfs() -> Int {
        return (self.new_serfs);
    }

    func get_dead_serfs() -> Int {
        return (self.dead_serfs);
    }

    func get_immigrated_serfs() -> Int {
        return (self.transplanted_serfs);
    }

    func get_fleeing_serfs() -> Int {
        return (self.fleeing_serfs);
    }

    func get_market_places() -> Int {
        return (self.market_places);
    }

    func get_market_revenue() -> Int {
        return (self.market_revenue);
    }

    func get_mills() -> Int {
        return (self.mills);
    }

    func get_mill_revenue() -> Int {
        return (self.mills_revenue);
    }

    func get_soldiers() -> Int {
        return (self.soldiers);
    }

    func get_soldier_pay() -> Int {
        return (self.soldiers_pay);
    }

    func get_invade_me() -> Bool {
        return (self.invade_me);
    }

    func get_customs_duty() -> Float {
        return (self.customs_duty);
    }

    func get_customs_duty_revenue() -> Float {
        return (self.customs_duty_revenue);
    }

    func get_sales_tax() -> Float {
        return (self.sales_tax);
    }

    func get_sales_tax_revenue() -> Float {
        return (self.sales_tax_revenue);
    }

    func get_income_tax() -> Float {
        return (self.income_tax);
    }

    func get_income_tax_revenue() -> Float {
        return (self.income_tax_revenue);
    }

    func get_justice_revenue() -> Float {
        return (self.justice_revenue);
    }

    func get_justice() -> Int {
        return (self.justice);
    }

    func get_bankrupt() -> Bool {
        return (self.is_bankrupt);
    }

    func get_year_of_death() -> Int {
        return (self.year_of_death);
    }
 }
