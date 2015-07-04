public class UnitTests {

  private boolean passed = true;

  public void runTests(){
    console.log("============ UNIT TESTS =============== ");

    ConvolutionFilter b ;

    b = new BoxFilter(3);
    assertTrue( 1 - sumMatrix(b.getMatrix()) < 0.000001 );

    b = new GaussianBlur(3,1);
    assertTrue( 1 - sumMatrix(b.getMatrix()) < 0.000001 );

    terminateTests();
  }

  public void terminateTests(){
    if(passed){
      console.log("ALL TESTS PASSING ! OK. YOU'RE GOOD TO GO!");
    }
  }

  public boolean assertTrue(boolean b){
    if(!b){
      console.log("ASSERTION FAILED");
      passed = false;
    }
  }

  public float sumMatrix(float[][] m){
    float sum = 0.0;
    for(int i = 0; i < m.length; i++)
      for(int j = 0; j < m[i].length; j++ )
        sum += m[i][j];

    return sum;
  }

}
