functor
export
    decode:Decode
    executeBlockchain:ExecuteBlockchain
define

    %% STUDENT START:
    
    %% PUT ANY AUXILIARY/HELPER FUNCTIONS THAT YOU NEED

    % Cette fonction convertit un nombre (10 à 36) en lettre selon le tableau donné
    fun {NumberToLetter N}
        case N of 10 then "a" 
        [] 11 then "b"
        [] 12 then "c"
        [] 13 then "d"
        [] 14 then "e"
        [] 15 then "f"
        [] 16 then "g"
        [] 17 then "h"
        [] 18 then "i"
        [] 19 then "j"
        [] 20 then "k"
        [] 21 then "l"
        [] 22 then "m"
        [] 23 then "n"
        [] 24 then "o"  
        [] 25 then "p"  
        [] 26 then "q"  
        [] 27 then "r"      
        [] 28 then "s"
        [] 29 then "t"
        [] 30 then "u"    
        [] 31 then "v"
        [] 32 then "w"    
        [] 33 then "x"       
        [] 34 then "y"   
        [] 35 then "z"     
        [] 36 then " "  
        else "" end
    end

    % Cette fonction transforme un hash en string
    fun {DecodeHash H}
        S = {Int.toString H}

        fun {Go L}
            case L of nil then nil

            [] H1|H2|T then
                N = ((H1 - &0) * 10 + (H2 - &0)) mod 37
                M = if N < 10 then 36 else N end
            in
                {NumberToLetter M} | {Go T}

            [] [H1|H2|T] then
                {Go H1|H2|T}

            [] _ then nil
            end
        end
    in
        {Go {String.tokens S nil}}
    end

    % Cette fonction calcule l'effort nécessaire pour effectuer une transaction
    fun {CalculEffort Value}
        S = {Int.toString Value}
        Len = {Length S}
        fun {Pow2 N}
            if N == 0 then 1
            else 2 * {Pow2 N-1}
            end
        end
    in
        {Pow2 Len} - 1 % Formule d'une somme géométrique de raison 2
    end

    % Cette fonction calcule le hash d'une transaction
    fun {CalculTransactionHash Transaction}
        TransitionHash = (Transaction.nonce + Transaction.sender + Transaction.receiver + Transaction.value) mod 1000000
        in
            TransitionHash 
    end

    % Cette fonction calcule le hash d'un bloc
    fun {CalculBlockHash Block}
        local SumHashTransaction BlockHash in
            SumHashTransaction = {FoldL Block.transactions fun {$ Acc HashTransaction} Acc + {CalculTransactionHash HashTransaction.hash} end 0}

            BlockHash = (Block.number + Block.previousHash + SumHashTransaction) mod 1000000
            BlockHash 
        end
    end

    % Cette fonction vérifie si une transaction est valide
    fun {IsValidTransaction Transaction State}
        % TO-DO
    end

    % Cette fonction vérifie si un bloc est valide
    fun {IsValidBlock Block} % Vérifier si il faut pas d'autres paramètres en plus /!\
        % TO-DO
    end

    %% STUDENT END

    %% Return a string representation of the secret
    fun {Decode Blockchain}
        %% STUDENT START:
        
        %% STUDENT END
    end


    % This function is the starting point of the execution
    % The GenesisState and the Transactions are given as input and the function is expected to bound the FinalState and the FinalBlockchain to their respective final values.
    fun {ExecuteBlockchain GenesisState Transactions FinalState FinalBlockchain}
        %% STUDENT START:
        %% TODO
        %% STUDENT END
    end
end