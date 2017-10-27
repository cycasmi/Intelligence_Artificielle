%*******Personnes********
  % attributs:
  %    - personne,
  %    -sexe,
  %    -genre(de musique, film, jeu, sport...) ou lieu d'apparition.

% --- MUSIC RELATED ---
chanteur(celine_dion, femme, ballade).
chanteur(michael_jackson, homme, pop).
chanteur(X):-
    chanteur(X, _, _).

musicien(john_lewis, homme, jazz).
musicien(wolfgang_amadeus_mozart, homme, classique).
musicien(X):-
    musicien(X, _, _).

musique(jazz).
musique(classique).
musique(ballade).
musique(pop).

% --- School related ---
professeur(michel_gagnon, homme, genie_informatique).
professeur(michel_dagenais, homme, genie_logiciel).
professeur(X):-
    professeur(X, _, _).

departament(genie_informatique).
departament(genie_logiciel).

% --- Characters ---
personnage(blanche_neige, femme, film_disney).
personnage(garfield, homme, dessin_anime).
personnage(james_bond, homme,film_action).
personnage(mario, homme, jeu_video).
personnage(lara_croft, femme, jeu_video).
personnage(X):-
    personnage(X, _, _).


programme_genre(film_disney).
programme_genre(film_action).
programme_genre(dessin_anime).
programme_genre(jeu_video).

% --- religion ---
personnage_religion(pape_francois, homme, eglise).
personnage_religion(moise, homme, tables_de_la_loi).
personnage_religion(jesus, homme, christianisme).
personnage_religion(X):-
    personnage_religion(X, _, _).
symbole_de(eglise).
symbole_de(tables_de_la_loi).
symbole_de(christianisme).
% --- celebrités ---
celebrite(julie_snyder, femme, talk_show).
celebrite(brad_pitt, homme, mr_et_mrs_Smith).
celebrite(X):-
    celebrite(X, _,_).
show(mr_et_mrs_Smith).
show(talk_show).
% --- sportifs ---
sportif(rafael_nadal, homme, tennis).
sportif(eugenie_bouchard, femme, tennis).
sportif(jacques_villeneuve, homme, auto_racing).
sportif(X):-
    sportif(X, _,_).
sport(tennis).
sport(auto_racing).

% --- ecrivaints ---
ecrivain(jk_rowling, femme, harry_potter).
ecrivain(victor_hugo, homme, les_miserables).
ecrivain(X):-
    ecrivain(X,_,_).

livre(harry_potter).
livre(les_misserables).

% --Gouvernants --
gouverne(stephen_harper, homme, canada).
gouverne(barack_obama, homme, usa).
gouverne(cleopatre, femme, egypte_antique).
gouverne(X):-
    gouverne(X, _,_).
pays(canada).
pays(usa).
pays(egypte_antique).

%************ QUESTIONS Personne ***************
ask(artiste):-
    write('Est un artiste?'),
    read(Reponse),
    Reponse = 'oui'.
ask(chanteur):-
    write('Est un chanteur? '),
    read(Reponse),
    Reponse = 'oui'.
ask(musicien):-
    write('Est un musicien? '),
    read(Reponse),
    Reponse = 'oui'.
ask(ecrivain):-
    write('Est un ecrivain? '),
    read(Reponse),
    Reponse = 'oui'.
ask(professeur):-
    write('Est un professeur? '),
    read(Reponse),
    Reponse = 'oui'.
ask(personnage_religion):-
    write('Est lie a la religion?'),
    read(Reponse),
    Reponse = 'oui'.
ask(sportif):-
    write('Est un sportif? '),
    read(Reponse),
    Reponse = 'oui'.
ask(gouverne):-
    write('Est un politicien?'),
    read(Reponse),
    Reponse = 'oui'.
ask(celebrite):-
    write('Est un celebrite?'),
    read(Reponse),
    Reponse = 'oui'.

% ********Questions information suplemmentaire******************
ask(musicien, Z):-
    format('Le type de musique est ~w ? ',[Z]),
    read(Reponse),
    Reponse = 'oui'.
ask(ecrivain, Z):-
    format('Un de ses livres est ~w ? ',[Z]),
    read(Reponse),
    Reponse = 'oui'.
ask(professeur, Z):-
    format('Travaille dans le departement de ~w ? ',[Z]),
    read(Reponse),
    Reponse = 'oui'.
ask(personnage, Z):-
    format('Le personnage apparait dans un ~w ? ',[Z]),
    read(Reponse),
    Reponse = 'oui'.
ask(sportif, Z):-
    format('Le sport est ~w ? ',[Z]),
    read(Reponse),
    Reponse = 'oui'.
ask(gouverne, Z):-
    format('Gouverne ~w ? ',[Z]),
    read(Reponse),
    Reponse = 'oui'.
ask(celebrite, Z):-
    format('Apparait dans ~w ? ',[Z]),
    read(Reponse),
    Reponse = 'oui'.
ask(personnage_religion, Z):-
    format('Represent ~w ? ',[Z]),
    read(Reponse),
    Reponse = 'oui'.

% ***** Questions possees pour trouver la personne.
%   - X = personne
%   - Y = sexe
%   - Z: Z = -1 personnage fictif
%        Z = 1 personne reel
personne(X, Y, Z):-
    Z == -1,
    personnages(X, Y).

personne(X, Y, Z):-
    Z == 1,
    ask(artiste),
    artistes(X, Y).

personne(X,Y, Z):-
    Z == 1,
    sportifs(X, Y).

personne(X,Y,Z):-
    Z == 1,
    politiciens(X, Y).

personne(X, Y, Z):-
    Z == 1,
    celebrites(X, Y).

personne(X, Y, Z):-
    Z == 1,
    educateurs(X, Y).

personne(X, Y, Z):-
    Z == 1,
    religeux(X, Y).

% Fait la division entre les personnes et les personnages, ainsi
% que entre les hommes et les femmes
personne(X):-
    write('Est un personnage fictif?'),
    read(Fict),
    (
        Fict = 'oui' ->
        Z = -1; Z = 1
    ),
    write('Est du sexe masculin?'),
    read(Reponse),
    (
        Reponse = 'oui'->
        personne(X, homme, Z); personne(X, femme, Z)
    ).





%Agrupation des personnes en groupes.
artistes(X, Y) :-
    ask(chanteur),
    chanteur(X, Y, Z),
    musique(Z),
    ask(musicien, Z).
artistes(X, Y) :-
    ask(musicien),
    musicien(X, Y, Z),
    musique(Z),
    ask(musicien, Z).
artistes(X, Y) :-
    ask(ecrivain),
    ecrivain(X, Y, Z),
    livre(Z),
    ask(ecrivain, Z).

personnages(X, Y):-
    personnage(X, Y, Z),
    programme_genre(Z),
    ask(personnage, Z).

sportifs(X, Y):-
    ask(sportif),
    sportif(X, Y, Z),
    sport(Z),
    ask(sportif, Z).

politiciens(X, Y):-
    ask(gouverne),
    gouverne(X,Y, Z),
    pays(Z),
    ask(gouverne, Z).

educateurs(X, Y):-
    ask(professeur),
    professeur(X, Y, Z),
    departament(Z),
    ask(professeur, Z).

celebrites(X, Y):-
    ask(celebrite),
    celebrite(X, Y, Z),
    show(Z),
    ask(celebrite, Z).

religeux(X, Y):-
    ask(personnage_religion),
    personnage_religion(X, Y, Z),
    symbole_de(Z),
    ask(personnage_religion, Z).
