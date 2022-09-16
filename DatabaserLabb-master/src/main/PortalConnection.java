package main;


import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONString;

import java.sql.*; // JDBC stuff.
import java.util.Properties;

public class PortalConnection {

    // Set this to e.g. "portal" if you have created a database named portal
    // Leave it blank to use the default database of your database user
    static final String DBNAME = "labb";
    // For connecting to the portal database on your local machine
    static final String DATABASE = "jdbc:postgresql://localhost/"+DBNAME;
    static final String USERNAME = "postgres";
    static final String PASSWORD = "postgres";

    // For connecting to the chalmers database server (from inside chalmers)
    // static final String DATABASE = "jdbc:postgresql://brage.ita.chalmers.se/";
    // static final String USERNAME = "tda357_nnn";
    // static final String PASSWORD = "yourPasswordGoesHere";


    // This is the JDBC connection object you will be using in your methods.
    private Connection conn;

    public PortalConnection() throws SQLException, ClassNotFoundException {
        this(DATABASE, USERNAME, PASSWORD);  
    }

    // Initializes the connection, no need to change anything here
    public PortalConnection(String db, String user, String pwd) throws SQLException, ClassNotFoundException {
        Class.forName("org.postgresql.Driver");
        Properties props = new Properties();
        props.setProperty("user", user);
        props.setProperty("password", pwd);
        conn = DriverManager.getConnection(db, props);
    }



    // Register a student on a course, returns a tiny JSON document (as a String)
    public String register(String student, String courseCode){
        // Sanitized
        String query = "INSERT INTO Registrations VALUES (?, ?)";

        try(PreparedStatement ps = conn.prepareStatement(query)){

            ps.setString(1, student);
            ps.setString(2, courseCode);
            ps.executeUpdate();

            String res = "{\"success\":true}";
            return res;
        } catch (SQLException e) {
            return "{\"success\":false, \"error\":\""+getError(e)+"\"}";
        }

    }

    // Unregister a student from a course, returns a tiny JSON document (as a String)
    public String unregister(String student, String courseCode){
        //Voulnerable
        String query = "DELETE FROM Registrations WHERE student = '"+student+"' and course = '"+courseCode+"'";

        // Injection MAD111' OR '1'='1
        try(Statement ps = conn.createStatement()){



            int rows = ps.executeUpdate(query);
            //System.out.println("Rows: "+rows.toString());
            if(rows == 0) {
                return "{\"success\":false, \"error\":\" The student is not registered to that course\"}";
            }

            String res = "{\"success\":true}";
            return res;
        } catch (SQLException e) {
            return "{\"success\":false, \"error\":\""+getError(e)+"\"}";
        }

    }



    // Return a JSON document containing lots of information about a student, it should validate against the schema found in information_schema.json
    public String getInfo(String student) throws SQLException {


        String studentJson = "";
        String finishedJson = "";
        String registeredJson = "";

        try(PreparedStatement st = conn.prepareStatement(
            "SELECT jsonb_build_object (\n" +
                    "  'student', BasicInformation.idnr,\n" +
                    "  'name', BasicInformation.name,\n" +
                    "  'login', BasicInformation.login,\n" +
                    "  'program', BasicInformation.program,\n" +
                    "  'branch', BasicInformation.branch,\n" +
                    "  'seminarCourses', PathToGraduation.seminarCourses,\n" +
                    "  'mathCredits', PathToGraduation.mathCredits,\n" +
                    "  'researchCredits', PathToGraduation.researchCredits,\n" +
                    "  'totalCredits', PathToGraduation.totalCredits,\n" +
                    "  'canGraduate', PathToGraduation.qualified\n" +
                    "  \n" +
                    "  ) AS jsondata\n" +
                    "  FROM BasicInformation\n" +
                    "  LEFT JOIN PathToGraduation\n" +
                    "  ON PathToGraduation.student = BasicInformation.idnr\n" +
                    "  WHERE BasicInformation.idnr = ?;"
            );){
            
            st.setString(1, student);
            ResultSet rs = st.executeQuery();


            if(rs.next())
                studentJson =  rs.getString("jsondata");
            else
              return "{\"student\":\"does not exist :(\"}";
            
            }
        try(PreparedStatement st = conn.prepareStatement(
                "SELECT jsonb_agg(jsonb_build_object(\n" +
                        "    'course', Courses.name,\n" +
                        "    'code', Registrations.course,\n" +
                        "    'status', Registrations.status, \n" +
                        "    'position', COALESCE(CourseQueuePositions.place, null)\n" +
                        "     )) AS jsondata\n" +
                        "     FROM  Registrations\n" +
                        "     LEFT JOIN Courses\n" +
                        "     ON Courses.code = Registrations.course\n" +
                        "     LEFT JOIN CourseQueuePositions\n" +
                        "     ON CourseQueuePositions.course = Registrations.course AND CourseQueuePositions.student = Registrations.student\n" +
                        "     WHERE Registrations.student = ?"
        );){

            st.setString(1, student);
            ResultSet rs = st.executeQuery();


            if(rs.next())
                 registeredJson=  rs.getString("jsondata");
            else
                return "{\"student\":\"does not exist :(\"}";

        }
        try(PreparedStatement st = conn.prepareStatement(
                "SELECT jsonb_agg(jsonb_build_object(\n" +
                        "    'course', Courses.name,\n" +
                        "    'code', FinishedCourses.course,\n" +
                        "    'grade', FinishedCourses.grade, \n" +
                        "    'credits', FinishedCourses.credits \n" +
                        "     )) AS jsondata\n" +
                        "     FROM  FinishedCourses\n" +
                        "     LEFT JOIN Courses\n" +
                        "     ON Courses.code = FinishedCourses.course\n" +
                        "     WHERE FinishedCourses.student =  ?;\n"
        );){

            st.setString(1, student);
            ResultSet rs = st.executeQuery();


            if(rs.next())
                finishedJson =  rs.getString("jsondata");
            else
                return "{\"student\":\"does not exist :(\"}";

        }

        JSONObject object = new JSONObject(studentJson);

        if(finishedJson != null){
            JSONArray finished = new JSONArray(finishedJson);
            for(int i = 0; i < finished.length(); i++){
                object.append("finished", finished.get(i));
            }
        }
        if(registeredJson != null){
            JSONArray registered = new JSONArray(registeredJson);
            for (int i = 0; i< registered.length(); i++){
                object.append("registered", registered.get(i));
            }
        }

        return object.toString();


    }

    // This is a hack to turn an SQLException into a JSON string error message. No need to change.
    public static String getError(SQLException e){
       String message = e.getMessage();
       int ix = message.indexOf('\n');
       if (ix > 0) message = message.substring(0, ix);
       message = message.replace("\"","\\\"");
       return message;
    }
}