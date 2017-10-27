package test;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.PriorityQueue;
import java.util.Queue;

public class RushHour {

	/*
	 * representation du probleme : Les six lignes sont numerotees de haut en
	 * bas, de 0 a 5 et les 6 colonnes de gauche a droite, de 0 a 5.
	 *
	 * il y a nbcars voitures, numérotées de 0 a nbcars-1 pour chaque voiture i
	 * on a : - color[i] sa couleur - horiz[i] si la voiture est horizontale
	 * (vrai) ou verticale (faux) - len[i] sa longueur (2 ou 3) - moveon[i] la
	 * ligne (si horiz[i]) ou la colonne (sinon) où se trouve la voiture
	 *
	 */

	public int nbcars;
	public String[] color;
	public boolean[] horiz;
	public int[] len;
	public int[] moveon;

	public int nbMoves;
	/*
	 * la matrice free permet de savoir si une case est libre
	 */
	public boolean[][] free = new boolean[6][6];

	void initFree(State s) {
            //Fill the matrix Free with trues (its empty!)
            for (int i = 0; i < 6; i++)
            {
                for (int j = 0; j < 6; j++)
                {
                    free[i][j] = true;
                }
            }
            
            //Fill it with cars.
            for (int i = 0; i < nbcars; i++)
            {
                //Block the spaces where there is a horizontal cars
                if (horiz[i] == true)
                {
                    for (int lenght = 0; lenght < len[i]; lenght++)
                    {
                        free[moveon[i]][s.pos[i]+lenght] = false;
                    }
                }
                //Block the spaces where there is a vertical cars
                else
                {
                    for (int lenght = 0; lenght < len[i]; lenght++)
                    {
                        free[s.pos[i]+lenght][moveon[i]] = false;
                    }
                }
            }
	}

	/*
	 * renvoie la liste des déplacements possibles
	 */

	public ArrayList<State> moves(State s) {
		initFree(s); //Filling the board
                
                ArrayList<State> l = new ArrayList<State>(); //List of possible states reachable from 's'
                State newState;
		int mov; //possible movement a car can do
                
                for (int i = 0; i < nbcars; i++)
                {
                    mov = s.pos[i];

                    //Making 'mov' the following square after the car (without exceeding the board limits)
                    if (mov < 4) //case 1: cars with length 2
                       mov += 2;
                       
                    if (mov < 5 && len[i] == 3) //case 2: cars with length 2
                       mov++;
                    
                    //HORIZONTAL cars
                    if (horiz[i] == true)
                    {
                       //MOVING FORWARD (right)
                       if (free[moveon[i]][mov] == false) 
                           ;
                       else //if the next square is free save new possible state
                       {
                           newState = new State(s, i, 1);
                           l.add(newState);
                       }                        
                       
                       //MOVING BACKWARDS (left)
                       mov = s.pos[i]; //initial position of the car
                       if (mov > 0) //Making 'mov' a square before the car (without exceeding the board limits)
                           mov--;
                       
                       //if the previous square is free save new possible state
                       if (free[moveon[i]][mov] == false)
                           continue;
                       else
                       {
                           newState = new State(s, i, -1);
                           l.add(newState);
                       }                    
                    }
                    
                    //VERTICAL CARS
                    else
                    {
                       //MOVING FORWARD (down)
                       if (free[mov][moveon[i]] == false)
                           ;
                       else
                       {
                           newState = new State(s, i, 1);
                           l.add(newState);
                       }
                       
                       //MOVING BACKWARDS (up)
                       mov = s.pos[i]; 
                       if (mov > 0) //Making 'mov' a square before the car (without exceeding the board limits)
                           mov--;
                        
                       //if the previous square is free save new possible state
                       if (free[mov][moveon[i]] == false)
                           continue;
                       else
                       {
                           newState = new State(s, i, -1);
                           l.add(newState);
                       }                    
                    }
                }
		return l; //return list of possible states
	}

	/*
	 * trouve une solution à partir de s
	 */
	public State solve(State s) {
            HashSet<State> visited = new HashSet<State>();
            visited.add(s);
            Queue<State> Q = new LinkedList<State>();
            
             ArrayList<State> movements; //list of the possible movements
             Q.add(s); //adding the initial state to the Queue
                     
             while (!Q.isEmpty())
             {
                 //If the actual state is sucessful
                 if (Q.peek().success())//{
                     //System.out.println("Nombre de etats visitees: " + visited.size());
                     return Q.remove();
                 //}
                 
                 else
                 {
                     //Look for the reachable states of the State in the head position
                     movements = moves(Q.remove());
                     
                     for (int i = 0; i < movements.size(); i++)
                     {
                         //Check if the state has already been explored
                         if (visited.contains(movements.get(i)))
                             ;
                         else
                         {
                             //add unexplored state to the lists
                             Q.add(movements.get(i)); 
                             visited.add(movements.get(i));
                         }
                     }
                 }
             }
             
            System.out.println("Nombre de etats visitees: " + visited.size());
            return null;
	}

	public State solveAstar(State s) {
            HashSet<State> visited = new HashSet<State>();
            visited.add(s);
            PriorityQueue<State> Q = new PriorityQueue<State>(10, new MyComparator());

             ArrayList<State> movements; //list of the possible movements
             Q.add(s); //adding the initial state to the Queue

             while (!Q.isEmpty())
             {
                 //If the actual state is sucessful
                 if (Q.peek().success())//{
                     //System.out.println("Nombre de etats visitees: " + visited.size());
                     return Q.remove();
                     //}

                 else
                 {
                     //Look for the reachable states of the State in the head position
                     movements = moves(Q.remove());

                     for (int i = 0; i < movements.size(); i++)
                     {
                         //Check if the state has already been explored
                         if (visited.contains(movements.get(i)))
                             ;
                         else
                         {
                             //add unexplored state to the lists
                             Q.add(movements.get(i)); 
                             visited.add(movements.get(i));
                         }
                     }
                 }
             }       
            return null;
	}

	/*
	 * affiche la solution
	 */

	void printSolution(State s) {
            
            if (s == null)
                System.out.println(nbMoves-1);
            else
            {
                nbMoves++;
                printSolution(s.prev);
                
                if (s.prev != null)
                {
                    for (int i = 0; i < nbcars; i++)
                    {
                        if (s.pos[i] == s.prev.pos[i])
                            ;
                        else if (s.pos[i] > s.prev.pos[i])
                        {
                            if (horiz[i] == true)
                                System.out.println("Voiture " + color[i] + " vers la droit");
                            else
                                System.out.println("Voiture " + color[i] + " vers le bas");
                        }
                        else if (s.pos[i] < s.prev.pos[i])
                        {
                            if (horiz[i] == true)
                                System.out.println("Voiture " + color[i] + " vers la gauche");
                            else
                                System.out.println("Voiture " + color[i] + " vers le haut");
                        }
                    }
                } 
            }
            
	}
	
	private class MyComparator implements Comparator<State> {
		@Override
		public int compare(State arg0, State arg1) {
			return arg0.f - arg1.f;
		}
	}
}

