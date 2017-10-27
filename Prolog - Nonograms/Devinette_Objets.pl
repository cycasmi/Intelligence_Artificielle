% ******** OBJECTS LIST **********
% Object
  % attributs:
  %    - name of the object,
  %    -electric/not_electric,
  %    -function
%** Its important to add the function to the database too!

appareil_electronique(grille_pain, electrique, griller_le_pain).
appareil_electronique(four_micro_onde, electrique, echauffaire_instantanement).
appareil_electronique(cafetiere, electrique, faire_du_cafe).
appareil_electronique(telephone, electrique, faire_appels).
appareil_electronique(ordinateur, electrique, faire_travailles).
appareil_electronique(X):-
    appareil_electronique(X,_,_).

meuble(lit, electrique, dormir).
meuble(cuisiniere, electrique,echauffaire).
meuble(table, nonelectrique, manger).
meuble(cuisiniere, nonelectrique, echauffaire).
meuble(X):-
    meuble(X,_,_).

objet_portable(cle, nonelectrique, ouvrir_portes).
objet_portable(sac_a_dos, nonelectrique, porter_choses).
objet_portable(porte_feuille, nonelectrique, porter_argent).
objet_portable(X):-
   objet_portable(X,_,_).

article_nettoyage(aspirateur, electrique, nettoyer).
article_nettoyage(balai, nonelectrique, nettoyer).
article_nettoyage(X):-
    article_nettoyage(X,_,_).

outil_cuisine(assiette, nonelectrique, manger).
outil_cuisine(casserole, nonelectrique, echauffaire).
outil_cuisine(X):-
    outil_cuisine(X,_,_).

produit_nettoyage(detergent_a_vaisselle, nonelectrique, nettoyer).
produit_nettoyage(X):-
    produit_nettoyage(X,_,_).
appareil_illumination(lampe, electrique, illuminer).
appareil_illumination(X):-
    appareil_illumination(X,_,_).
couverte(fourchette, nonelectrique, manger).
couverte(X):-
    couverte(X,_,_).
instrument_musical(piano, nonelectrique, avec_des_touches).
instrument_musical(X):-
    instrument_musical(X,_,_).
plant(cactus, nonelectrique, decorer_habitation).
plant(X):-
    plant(X,_,_).
article_papeterie(papier, nonelectrique, ecrire_sur_lui).
article_papeterie(X):-
    article_papeterie(X,_,_).
produit_hygiene_personnelle(shampooing, nonelectrique, nettoyer).
produit_hygiene_personnelle(X):-
    produit_hygiene_personnelle(X,_,_).


% ********* Functions definitions *********
fonction(echauffaire).
fonction(manger).
fonction(nettoyer).
fonction(ecrire_sur_lui).
fonction(ouvrir_portes).
fonction(dormir).
fonction(illuminer).
fonction(faire_appels).
fonction(decorer_habitation).
fonction(faire_travailles).
fonction(avec_des_touches).
fonction(porter_choses).
fonction(porter_argent).
fonction(echauffaire_instantanement).
fonction(faire_du_cafe).
fonction(griller_le_pain).

% *********** Questions ********
ask(meuble):-
    write('Est il un meuble?'),
    read(Reponse),
    Reponse = 'oui'.

ask(appareil_electronique):-
    write('Est il un appareil_electronioque'),
    read(Reponse),
    Reponse = 'oui'.

ask(appareil_illumination):-
    write('Est il un appareil de illumination'),
    read(Reponse),
    Reponse = 'oui'.

ask(outil_cuisine):-
    write('Est il un outil qui se trouve dans la cuisine? '),
    read(Reponse),
    Reponse = 'oui'.

ask(couverte):-
    write('Est il un couverte? '),
    read(Reponse),
    Reponse = 'oui'.

ask(objet_portable):-
    write('Est il un objet portable? '),
    read(Reponse),
    Reponse = 'oui'.

ask(instrument_musical):-
    write('Est il un instrument musical '),
    read(Reponse),
    Reponse = 'oui'.

ask(plant):-
    write('Est il un plant? '),
    read(Reponse),
    Reponse = 'oui'.

ask(article_bureau):-
    write('Est il un article_bureau? '),
    read(Reponse),
    Reponse = 'oui'.

ask(produit_hygiene_personnelle):-
    write('Il est pour le hygiene personnelle '),
    read(Reponse),
    Reponse = 'oui'.

ask(article_nettoyage):-
    write('Il est pour faire le menage? '),
    read(Reponse),
    Reponse = 'oui'.

ask(produit_nettoyage):-
    write('Il est un produit pour nettoyager'),
    read(Reponse),
    Reponse = 'oui'.

ask(article_papeterie):-
    write('Il est un article de papeterie? '),
    read(Reponse),
    Reponse = 'oui'.


ask(fonction, Z):-
    format('Il sert a ~w ? ',[Z]),
    read(Reponse),
    Reponse = 'oui'.

% ******** Mayor subdivision of objects **********
objet(X):-
    not(ground(X)),
    write('Il fonctione avec electricite?'),
    read(E),
    (
        E = 'oui' ->
        objet(X, electrique); objet(X, nonelectrique)
    ).

% Giving the possibility of determine if X is an object in the database
objet(X):-
    ground(X),
    meuble(X,_,_).
objet(X):-
    ground(X),
    appareil_electronique(X,_,_).
objet(X):-
    ground(X),
    objet_portable(X,_,_).
objet(X):-
    ground(X),
    article_nettoyage(X,_,_).
objet(X):-
    ground(X),
    outil_cuisine(X,_,_).
objet(X):-
    ground(X),
    appareil_illumination(X,_,_).
objet(X):-
    ground(X),
    instrument_musical(X,_,_).
objet(X):-
    ground(X),
    article_papeterie(X,_,_).
objet(X):-
    ground(X),
    plant(X,_,_).

objet(X):-
    ground(X),
    couverte(X,_,_).

objet(X):-
    ground(X),
    produit_hygiene_personnelle(X,_,_).

objet(X):-
    ground(X),
    produit_nettoyage(X,_,_).



% Search of the object
objet(X, electrique):-
    ask(appareil_electronique),
    appareil_electronique(X, electrique, Z),
    fonction(Z),
    ask(fonction, Z).

objet(X, Y):-
    ask(meuble),
    meuble(X, Y, Z),
    fonction(Z),
    ask(fonction, Z).

objet(X, Y):-
    ask(objet_portable),
    objet_portable(X, Y, Z),
    fonction(Z),
    ask(fonction, Z).

objet(X, Y):-
    ask(article_nettoyage),
    article_nettoyage(X, Y, Z),
    fonction(Z),
    ask(fonction, Z).

objet(X, Y):-
    ask(outil_cuisine),
    outil_cuisine(X, Y, Z),
    fonction(Z),
    ask(fonction, Z).

objet(X, Y):-
    ask(appareil_illumination),
    appareil_illumination(X, Y, Z),
    fonction(Z),
    ask(fonction, Z).

objet(X, Y):-
    ask(instrument_musical),
    instrument_musical(X, Y, Z),
    fonction(Z),
    ask(fonction, Z).
objet(X, Y):-
    ask(plant),
    plant(X, Y, Z),
    fonction(Z),
    ask(fonction, Z).

objet(X, Y):-
    ask(couverte),
    couverte(X, Y, Z),
    fonction(Z),
    ask(fonction, Z).

objet(X, Y):-
    ask(article_papeterie),
    article_papeterie(X, Y, Z),
    fonction(Z),
    ask(fonction, Z).

objet(X, Y):-
    ask(produit_hygiene_personnelle),
    produit_hygiene_personnelle(X, Y, Z),
    fonction(Z),
    ask(fonction, Z).

objet(X, Y):-
    ask(produit_nettoyage),
    produit_nettoyage(X, Y, Z),
    fonction(Z),
    ask(fonction, Z).
