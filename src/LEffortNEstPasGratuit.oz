% Extension 2 - L'effort n'est pas gratuit %

% à modifier
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
        Chars = S

        fun {Go L}
            case L
            of H1|H2|T then
                N = ((H1-&0)*10 + (H2-&0)) mod 37
                M = if N < 10 then 36 else N end
            in
                {Append {NumberToLetter M} {Go T}}
            [] _ then ""
            end
        end
    in
        {VirtualString.toString {Go Chars}}
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
            SumHashTransaction = {FoldL Block.transactions fun {$ Acc Transaction} Acc +  Transaction.hash end 0}

            BlockHash = (Block.number + Block.previousHash + SumHashTransaction) mod 1000000
            BlockHash 
        end
    end

    % Cette fonction vérifie si une transaction est valide
    fun {IsValidTransaction Transaction State}
        local
            Sender = Transaction.sender
            % Vérification si sender est dans la liste de State
            HasSender = {HasFeature State Sender} 
        in
            if HasSender==false then false
            
            else
                local 
                    UserInfo = State.(Sender)
                in
                    if Transaction.nonce \= UserInfo.nonce + 1 then false
                    elseif Transaction.hash \= {CalculTransactionHash Transaction} then false
                    elseif Transaction.value < 0 then false
                    elseif Transaction.max_effort < 0 then false
                    elseif {CalculEffort Transaction.value} > Transaction.max_effort then false
                    elseif UserInfo.balance < Transaction.value then false
                    else true
                    end
                end
            end
        end
    end


    % Cette fonction retourne le block précédent
    fun{GetPreviousBlock CurrentBlock Blockchain}
        case Blockchain
        of nil then nil
        [] H|T then
            if H.hash == CurrentBlock.previousHash then H 
            else {GetPreviousBlock CurrentBlock T}
            end
        end
    end



    % Cette fonction vérifie si un bloc est valide
    fun {IsValidBlock Block Blockchain State}
        local 
            %Trouver le bloc précédent
            PreviousBlock = {GetPreviousBlock Block Blockchain}

            %Calculer l'effort total
            TotalEffort = {FoldL Block.transactions fun{$ Acc Transaction} Acc + {CalculEffort Transaction.value} end 0}

            %Vérification que toutes les transactions sont valides grace à la fonction All
            AllTransactionsValidity = {List.all Block.transactions fun {$ Transaction} {IsValidTransaction Transaction State} end}

        in
            if PreviousBlock == nil then
                    if Block.number \= 0 then false
                    elseif Block.previousHash \= 0 then false
                    elseif Block.hash \= {CalculBlockHash Block} then false
                    elseif Block.transactions == nil then false
                    elseif AllTransactionsValidity ==false then false
                    elseif TotalEffort > 300 then false
                    else true
                    end

            else
                    if Block.number \= PreviousBlock.number +1 then false
                    elseif Block.previousHash \= PreviousBlock.hash then false
                    elseif Block.hash \= {CalculBlockHash Block} then false
                    elseif Block.transactions == nil then false
                    elseif AllTransactionsValidity ==false then false
                    elseif TotalEffort > 300 then false
                    else true
                    end
                end
            end
        end

    %% STUDENT END

    %% Return a string representation of the secret
    fun {Decode Blockchain}
        case Blockchain
        of nil then ""
        [] B|T then
            {Append {DecodeHash B.hash} {Decode T}}
        end
    end
    %% STUDENT END


    % This procedure is the starting point of the execution
    % The GenesisState and the Transactions are given as input and the rocedure is expected to bound the FinalState and the FinalBlockchain to their respective final values.
    proc {ExecuteBlockchain GenesisState Transactions FinalState FinalBlockchain}
        %% STUDENT START:
        local 
        BuildState AddEffortTransactions Loop UpdateState 
        InitialState TransactionWithEffort TempBlockchain TempState
        in
            % Étape 1 : Construire le State initial
            fun {BuildState GenesisStateRecord}
                fun {Transform List}
                    case List of nil then nil
                    [] (User#Balance)|T then
                        (User#user(balance:Balance nonce:0))|{Transform T}
                    end
                end
            in
                {List.toRecord state {Transform {Record.toListInd GenesisStateRecord}}}
            end

            % Étape 2 : Ajouter l’effort aux transactions
            fun {AddEffortTransactions TransactionsList}
                case TransactionsList
                of nil then nil
                [] T1|T2 then
                    local
                        EffortT1 = {CalculEffort T1.value}
                    in
                        % {AdjoinAt Record Feature Value} fonction built-in qui ajoute un champ à un record :-)
                        {AdjoinAt T1 effort EffortT1}|{AddEffortTransactions T2} 
                    end
                end
            end

            % Étape 3 : Mise à jour du State
            fun {UpdateState Transaction State}
                local
                    Sender = Transaction.sender
                    Receiver = Transaction.receiver
                    Value = Transaction.value
                    NewSender
                    NewReceiver
                in
                    
                    % Mise à jour du state de l'envoyeur
                    NewSender = user(balance: State.(Sender).balance - Value nonce: Transaction.nonce)

                    % Mise à jour du state de récepteur
                    if {HasFeature State Receiver} then 
                        NewReceiver = user(balance : State.(Receiver).balance + Value nonce: State.(Receiver).nonce)
                    else
                        NewReceiver = user(balance: Value nonce: 0)
                    end

                    {AdjoinList State [Sender#NewSender Receiver#NewReceiver]}
                end
            end

            % Étape 4 : Parcourir NewTransactions et filtrer les transactions valides
            fun {Loop Ts CurrentBlockNum CurrentTxs Effort Blockchain State PrevHash}
                case Ts
                of nil then 
                    BlockHash = (CurrentBlockNum + PrevHash + {FoldL CurrentTxs fun {$ A T} A + T.hash end 0}) mod 1000000
                    Block = block(number:CurrentBlockNum previousHash:PrevHash transactions:{Reverse CurrentTxs} hash:BlockHash)
                in
                    (Block|Blockchain) # State

                [] T|Rest then
                    if T.block_number \= CurrentBlockNum then
                        BlockHash = (CurrentBlockNum + PrevHash + {FoldL CurrentTxs fun {$ A X} A + X.hash end 0}) mod 1000000
                        Block = block(number:CurrentBlockNum previousHash:PrevHash transactions:{Reverse CurrentTxs} hash:BlockHash)
                    in
                        {Loop Ts T.block_number nil 0 (Block|Blockchain) State BlockHash}

                    else
                        local
                            Eff = T.effort
                        in
                            if {IsValidTransaction T State} andthen Effort + Eff =< 300 then 
                                NewState = {UpdateState T State}
                            in
                                {Loop Rest CurrentBlockNum (T|CurrentTxs) (Effort+Eff) Blockchain NewState PrevHash}
                            else
                                {Loop Rest CurrentBlockNum CurrentTxs Effort Blockchain State PrevHash}
                            end
                        end
                    end
                end
            end

            InitialState = {BuildState GenesisState}
            TransactionWithEffort = {AddEffortTransactions Transactions}
            TempBlockchain # TempState = {Loop TransactionWithEffort 0 nil 0 nil InitialState 0}

            FinalState = TempState
            FinalBlockchain = {Reverse TempBlockchain}
            %% STUDENT END
        end
    end
end