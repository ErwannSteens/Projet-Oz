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
        S L Go in
        S = {Int.toString H}
        L = {String.toList S}

        fun {Go L}
            case L of nil then ""
            [] H1|T1 then
                case T1 of
                    H2|T then
                        Pair N M Letter in
                        Pair = {String.fromList [H1 H2]}
                        N = {String.toInt Pair} mod 37
                        M = if N < 10 then 36 else N end
                        Letter = {NumberToLetter M}
                        Letter # {Go T}
                [] nil then "" end
            end
        end
        {Go L}
    end


    %% STUDENT END

    %% Return a string representation of the secret
    fun {Decode Blockchain}
        %% STUDENT START:
        %% TODO
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


% Tests %
{System.showInfo {NumberToLetter 10}} % J'utilise System.showInfo pour avoir la lettre sinon c'est en ASCII :/