declare
fun {NumberToLetter N}
   case N of
      10 then "a" [] 11 then "b" [] 12 then "c"
   [] 13 then "d" [] 14 then "e" [] 15 then "f"
   [] 16 then "g" [] 17 then "h" [] 18 then "i"
   [] 19 then "j" [] 20 then "k" [] 21 then "l"
   [] 22 then "m" [] 23 then "n" [] 24 then "o"
   [] 25 then "p" [] 26 then "q" [] 27 then "r"
   [] 28 then "s" [] 29 then "t" [] 30 then "u"
   [] 31 then "v" [] 32 then "w" [] 33 then "x"
   [] 34 then "y" [] 35 then "z" [] 36 then " "
   else ""
   end
end

fun {DecodeHash H}
   S = {Int.toString H}

   fun {Go L}
      case L of
         nil then nil

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

{System.showInfo {NumberToLetter 10}} % J'utilise System.showInfo pour avoir la lettre sinon c'est en ASCII :/
{System.showInfo {Flatten {DecodeHash 285110}}}
{Show {CalculEffort 500}}