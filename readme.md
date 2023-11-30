
# A simple, minimal Maven example: hello world

I changed the message to "Hello World! And Eden!" and Set the Jar version to 1.0.0

added a corresponding Dockerfile that builds the application and runs the application with a non-root user. (using Multistage Docker )

added 2 workflows:

1. .github/workflows/maven.yaml - only packages the app with maven
2. .github/workflows/ci.yaml - 
  a. Increases the Patch part of the jar version automatically
  b. builds and pushes the image(with new tag) to my dockerhub (https://hub.docker.com/r/edenzil/myapp)
  c. runs the application with the non-root user

finally i added a helm-chart that deploys my application on kubernetes.

----------------------------------------------------------------------------------------------------------------------------------

To create the files in this git repo we've already run `mvn archetype:generate` from http://maven.apache.org/guides/getting-started/maven-in-five-minutes.html
    
    mvn archetype:generate -DgroupId=com.myapp.app -DartifactId=myapp -DarchetypeArtifactId=maven-archetype-quickstart -DarchetypeVersion=1.4 -DinteractiveMode=false

Now, to print "Hello World!", type either...

    cd myapp
    mvn compile
    java -cp target/classes com.myapp.app.App

or...

    cd myapp
    mvn package
    java -cp target/myapp-1.0-SNAPSHOT.jar com.myapp.app.App

Running `mvn clean` will get us back to only the source Java and the `pom.xml`:

    murphy:myapp pdurbin$ mvn clean --quiet
    murphy:myapp pdurbin$ ack -a -f
    pom.xml
    src/main/java/com/myapp/App.java
    src/test/java/com/myapp/AppTest.java

Running `mvn package` does a compile and creates the target directory, including a jar:

    murphy:myapp pdurbin$ mvn clean --quiet
    murphy:myapp pdurbin$ mvn package > /dev/null
    murphy:myapp pdurbin$ ack -a -f
    pom.xml
    src/main/java/com/myapp/App.java
    src/test/java/com/myapp/AppTest.java
    target/classes/com/myapp/App.class
    target/maven-archiver/pom.properties
    target/myapp-1.0-SNAPSHOT.jar
    target/surefire-reports/com.myapp.app.AppTest.txt
    target/surefire-reports/TEST-com.myapp.app.AppTest.xml
    target/test-classes/com/myapp/AppTest.class
    murphy:myapp pdurbin$ 
    murphy:myapp pdurbin$ java -cp target/myapp-1.0-SNAPSHOT.jar com.myapp.app.App
    Hello World!
