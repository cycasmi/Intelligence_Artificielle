package test;

public class State {
	/*
	 * pos donne la position de la voiture i dans sa ligne ou colonne (première
	 * case occupée par la voiture)
	 */
	public int[] pos;

	/*
	 * c,d et prev premettent de retracer l'état précédent et le dernier
	 * mouvement effectué
	 */
	public int c;
	static private RushHour rh;
	public int d;
	public State prev;
	/*
	 * à utiliser dans la deuxième partie, 
	 * n indique la distance entre l'état
	 * actuel et l'état initial, f le coût de l'état actuel.
	 */
	public int n;
	public int f = 0; //the actual cost varies depending on the method "estimee" used. 
	/*
	 * Contructeur d'un état initial (& recebem qualquer valor = lixo)
	 */
	public State(int[] p, RushHour rh) {
		n = 0;
		int tam = p.length;
		pos = new int[tam];
		for (int i = 0; i < tam; i++)
			pos[i] = p[i];
		prev = null;
		State.rh = rh;
	}

	/*
	 * constructeur d'un état à partir d'un état s et d'un mouvement (c,d)
	 */
	public State(State s, int c, int d) {
            
                n += s.n; //taking in consideration the previous number of movements
                
                //Creating a pos vector for the new state (we dont want to modify the previous state!)
                int[] temp = new int [s.pos.length];
                for (int i = 0; i < s.pos.length; i++)
			temp[i] = s.pos[i];
                
                this.prev = s; //saving the previous state.
                this.pos = temp; //filling the positions with previous ones
                this.pos[c] = pos[c] + d; //Modifying the positions to create the new state
	
                n++; //Incrementing the number of movements made to achive the state.
                
                if (rh != null) //"IF" for avoiding Test1 to fail (rh in Test1 is NULL)
                    f = n + estimee1();
        }


	// this est il final?
	public boolean success() {
            if (pos[0] == 4)
                return true;
            else            
                return false;
	}

	/*
	 * Estimation du nombre de coup restants
	 */
        
        //Estimate the cost for finding a solution as the distance
        //between the red car and the finish line
	public int estimee1() {
		return 4 - pos[0];
	}

        //Estimate the cost for finding a solution as the distance
        //between the red car and the finish line AND the number of
        //cars that blocks its way
	public int estimee2() {
		int distanceSortie = 4 - pos[0];
                int numVoitures = 0;
                
                //Case the red car is already in the finish line
                if (pos[0] == 4)
                    return 0;
                else
                {
                  for (int i = 1; i < rh.nbcars; i++ )
                  {
                      //Checking for horizontal cars blocking the way
                      if (rh.horiz[i])
                      {
                          if (pos[i] <= pos[0]+1)//the car is before the red car
                          continue;
                          
                          if (rh.moveon[i] == 2) //the car is in some point of the red car's way
                              numVoitures++;
                      }
                      //Checking for vertical cars blocking the way
                      else
                      {
                          //the car is before the red car
                          if (rh.moveon[i] <= pos[0]+1)
                          continue;
                          
                          //Checking if the car is long enough to block red car's way. (or placed in the way)
                          if (pos[i] == 0 && rh.len[i] == 3)
                              numVoitures++;
                          
                          else if (pos[i] == 1 || pos[i] == 2)
                              numVoitures++;
                      }
                  }
                }
		return distanceSortie + numVoitures;
	}

	@Override
	public boolean equals(Object o) {
		State s = (State) o;
		if (s.pos.length != pos.length) {
			System.out.println("les états n'ont pas le même nombre de voitures");
		}
		int tamanho = pos.length;

		for (int i = 0; i < tamanho; i++)
			if (pos[i] != s.pos[i])
				return false;
		return true;
	}

	@Override
	public int hashCode() {
		int h = 0;
		for (int i = 0; i < pos.length; i++)
			h = 37 * h + pos[i];
		return h;
	}

	
}
