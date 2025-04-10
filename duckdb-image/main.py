import duckdb
import time
import sys
import socket
import os

def initialize_duckdb():
    # Connect to an in-memory database
    print("Connecting to DuckDB...")
    conn = duckdb.connect(':memory:')
    
    # Install and load necessary extensions
    print("Installing and loading extensions...")
    conn.execute('INSTALL httpfs;')
    conn.execute('LOAD httpfs;')
    conn.execute("INSTALL 'sqlite';")
    conn.execute("LOAD 'sqlite';")
    
    # Create example table and insert data
    print("Creating example table...")
    conn.execute("""
        CREATE TABLE IF NOT EXISTS example (
            id INTEGER,
            name VARCHAR
        );
    """)
    conn.execute("""
        INSERT INTO example VALUES 
            (1, 'Duck'),
            (2, 'DB');
    """)
    
    # Print available extensions
    print("\nAvailable extensions:")
    print(conn.execute("SELECT * FROM duckdb_extensions();").fetchall())
    
    # Print user and permissions info
    print(f"\nRunning as user: {os.getuid()}:{os.getgid()}")
    print(f"Current working directory: {os.getcwd()}")
    
    # Get host from environment variable or use default
    host = os.environ.get('DUCKDB_UI_HOST', '0.0.0.0')
    print(f"\nUsing host: {host}")
    
    # Start the server
    print("\nStarting DuckDB UI server...")
    try:
        # Try to start the server with a different approach
        conn.execute("CALL start_ui_server();")
        print("DuckDB UI server started successfully")
        
        # Wait a moment for the server to start
        time.sleep(2)
        
        # Test if the port is actually listening on different interfaces
        interfaces = ['127.0.0.1', '0.0.0.0']
        for interface in interfaces:
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            result = sock.connect_ex((interface, 4213))
            if result == 0:
                print(f"Port 4213 is open and listening on {interface}")
            else:
                print(f"Warning: Port 4213 is not accessible on {interface}")
            sock.close()
        
        # Print listening ports
        print("\nChecking listening ports:")
        os.system("netstat -tuln | grep 4213")
        
        # Try to connect to the server using curl
        print("\nTesting server connection:")
        os.system("curl -v http://localhost:4213/")
        
    except Exception as e:
        print(f"Error starting server: {str(e)}")
        sys.exit(1)
    
    # Keep the script running
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("\nShutting down DuckDB server...")
        sys.exit(0)

if __name__ == "__main__":
    initialize_duckdb()