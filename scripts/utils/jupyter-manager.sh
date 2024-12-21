# scripts/utils/jupyter-manager.sh
#!/bin/bash

JUPYTER_SERVICE="jupyter.service"
JUPYTER_PORT=8888
JUPYTER_CONFIG="$HOME/.jupyter/jupyter_server_config.py"

function status() {
    systemctl status $JUPYTER_SERVICE
}

function start() {
    sudo systemctl start $JUPYTER_SERVICE
    echo "Jupyter started. Available at:"
    echo "https://$(hostname -I | awk '{print $1}'):$JUPYTER_PORT"
}

function stop() {
    sudo systemctl stop $JUPYTER_SERVICE
}

function restart() {
    sudo systemctl restart $JUPYTER_SERVICE
}

function logs() {
    journalctl -u $JUPYTER_SERVICE -f
}

function password() {
    python3 -c "from jupyter_server.auth import passwd; print(passwd())"
}

function help() {
    echo "Jupyter Manager"
    echo "Usage: $0 {start|stop|restart|status|logs|password}"
    echo ""
    echo "Commands:"
    echo "  start     Start Jupyter server"
    echo "  stop      Stop Jupyter server"
    echo "  restart   Restart Jupyter server"
    echo "  status    Check Jupyter server status"
    echo "  logs      Show Jupyter server logs"
    echo "  password  Generate new password hash"
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    status)
        status
        ;;
    logs)
        logs
        ;;
    password)
        password
        ;;
    *)
        help
        ;;
esac
