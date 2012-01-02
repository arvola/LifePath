module Rapid
    module Transaction
        def start_transaction
            @transaction = true
        end

        def do_end_transaction db
            @updates.each do |key, val|
                do_update(db, key, val)
            end
            @transaction = nil
        end

        def updates condition
            @updates ||= {}
            @updates[condition] ||= {}
        end

        def update collection = nil, condition, values
            if @transaction
                updates(condition).update(values)
            elsif !collection.nil?
                Database.open collection do |db|
                    do_update db, condition, values
                end
            end
        end

        def do_update db, condition, values
            db.update(condition, {"$set" => values})
        end
    end
end