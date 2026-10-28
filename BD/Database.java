package servise;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Database {
    // URL com parâmetros recomendados para conexões locais
    private static final String URL = "jdbc:mysql://localhost:3306/amazonia_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASSWORD = "senha"; // <-- Substitua pela sua senha do MySQL

    public static Connection getConnection() throws SQLException {
        try {
            // Força o registro do driver MySQL na memória da JVM
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("CRÍTICO: O arquivo .jar do driver MySQL não foi encontrado no Classpath!");
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
