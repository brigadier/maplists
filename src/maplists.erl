%%%-------------------------------------------------------------------
%%% @author evgeny
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(maplists).

-export([keydelete/3, keyfind/3, keymap/3, keymember/3, keyreplace/4,
	keysearch/3, keysort/2, keystore/4, keytake/3, keymerge/3, ukeymerge/3,
	ukeysort/2]).


-spec keydelete(Key, Value, MapsList1) -> MapsList2 when
      Key :: term(),
      Value :: term(),
      MapsList1 :: [Map],
      MapsList2 :: [Map],
      Map :: map().

keydelete(K, V, [H | T]) ->
	case H of
		#{K := V} -> T;
		Else -> [Else | keydelete(K, V, T)]
	end;
keydelete(_, _, []) -> [].


-spec keyfind(Key, Value, MapsList) -> Map | false when
      Key :: term(),
      Value :: term(),
      MapsList :: [Map],
      Map :: map().

keyfind(K, V, [H | T]) ->
	case H of
		#{K := V} -> H;
		_ -> keyfind(K, V, T)
	end;
keyfind(_, _, []) ->
	false.


-spec keymap(Fun, Key, MapsList1) -> MapsList2 when
      Fun :: fun((Term1 :: term()) -> Term2 :: term()),
      Key :: term(),
      MapsList1 :: [Map],
      MapsList2 :: [Map],
      Map :: map().

keymap(F, K, L) ->
	[A#{K => F(map_get(K, A))} || A <- L].


-spec keymember(Key, Value, MapsList) -> boolean() when
      Key :: term(),
      Value :: term(),
      MapsList :: [Map],
      Map :: map().

keymember(K, V, [H | T]) ->
	case H of
		#{K := V} -> true;
		_ -> keymember(K, V, T)
	end;
keymember(_, _, []) -> false.


-spec keymerge(Key, MapsList1, MapsList2) -> MapsList3 when
      Key :: term(),
      MapsList1 :: [Map1],
      MapsList2 :: [Map2],
      MapsList3 :: [(Map1 | Map2)],
      Map1 :: Map,
      Map2 :: Map,
      Map :: map().

keymerge(K, L1, L2) ->
	keymerge(K, L1, L2, []).

keymerge(K, [H1 | L1T] = L1, [H2 | L2T] = L2, Acc) ->
	#{K := V1} = H1,
	#{K := V2} = H2,
	if
		V1 == V2 -> keymerge(K, L1T, L2T, [H1, H2 | Acc]);
		V1 =< V2 -> keymerge(K, L1T, L2, [H1 | Acc]);
		V1 > V2 -> keymerge(K, L1, L2T, [H2 | Acc])
	end;
keymerge(_, [], L2, Acc) -> lists:reverse(Acc, L2);
keymerge(_, L1, [], Acc) -> lists:reverse(Acc, L1).


-spec keyreplace(Key, Value, MapsList1, NewMap) -> MapsList2 when
      Key :: term(),
      Value :: term(),
      MapsList1 :: [Map],
      MapsList2 :: [Map],
      NewMap :: Map,
      Map :: map().

keyreplace(K, V, [H | T], N) ->
	case H of
		#{K := V} -> [N | T];
		_ -> [H | keyreplace(K, V, T, N)]
	end;
keyreplace(_, _, [], _) -> [].


-spec keysearch(Key, Value, MapsList) -> {value, Map} | false when
      Key :: term(),
      Value :: term(),
      MapsList :: [Map],
      Map :: map().

keysearch(K, V, T) ->
	case keyfind(K, V, T) of
		false -> false;
		Else -> {value, Else}
	end.


-spec keysort(Key, MapsList1) -> MapsList2 when
      Key :: term(),
      MapsList1 :: [Map],
      MapsList2 :: [Map],
      Map :: map().

keysort(K, L) ->
	lists:sort(
		fun(#{K := A}, #{K := B}) ->
			A =< B
		end,
		L
	).


-spec keystore(Key, Value, MapsList1, NewMap) -> MapsList2 when
      Key :: term(),
      Value :: term(),
      MapsList1 :: [Map],
      MapsList2 :: [Map, ...],
      NewMap :: Map,
      Map :: map().

keystore(K, V, [H | T], N) ->
	case H of
		#{K := V} -> [N | T];
		_ -> [H | keystore(K, V, T, N)]
	end;
keystore(_, _, [], N) -> [N].


-spec keytake(Key, Value, MapsList1) -> {value, Map, MapsList2} | false when
      Key :: term(),
      Value :: term(),
      MapsList1 :: [Map],
      MapsList2 :: [Map],
      Map :: map().

keytake(K, V, T) ->
	keytake(K, V, T, []).

keytake(K, V, [H | T], Acc) ->
	case H of
		#{K := V} -> {value, H, lists:reverse(Acc, T)};
		_ -> keytake(K, V, T, [H | Acc])
	end;
keytake(_, _, [], _) -> false.


-spec ukeymerge(Key, MapsList1, MapsList2) -> MapsList3 when
      Key :: term(),
      MapsList1 :: [Map1],
      MapsList2 :: [Map2],
      MapsList3 :: [(Map1 | Map2)],
      Map1 :: Map,
      Map2 :: Map,
      Map :: map().

ukeymerge(K, L1, L2) ->
	ukeymerge(K, L1, L2, []).

ukeymerge(K, [H1 | L1T] = L1, [H2 | L2T] = L2, Acc) ->
	#{K := V1} = H1,
	#{K := V2} = H2,
	if
		V1 == V2 -> ukeymerge(K, L1T, L2T, [H1 | Acc]);
		V1 =< V2 -> ukeymerge(K, L1T, L2, [H1 | Acc]);
		V1 > V2 -> ukeymerge(K, L1, L2T, [H2 | Acc])
	end;
ukeymerge(_, [], L2, Acc) -> lists:reverse(Acc, L2);
ukeymerge(_, L1, [], Acc) -> lists:reverse(Acc, L1).


-spec ukeysort(Key, MapsList1) -> MapsList2 when
      Key :: term(),
      MapsList1 :: [Map],
      MapsList2 :: [Map],
      Map :: map().

ukeysort(K, L) ->
	lists:usort(
		fun(#{K := A}, #{K := B}) ->
			A =< B
		end,
		L
	).