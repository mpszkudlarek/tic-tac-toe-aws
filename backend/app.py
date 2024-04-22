from flask import Flask, request, session
from flask_cors import CORS
from flask_socketio import SocketIO, emit, send, join_room, leave_room, close_room
from dotenv import load_dotenv
import os

load_dotenv()
app = Flask(__name__,
            static_folder="./dist/static",
            template_folder="./dist")
app.config['SECRET_KEY'] = os.getenv('SECRET_KEY', 'default_secret_key')
app.config['DEBUG'] = True

cors = CORS(app, resources={r"/api/*": {"origin": "*"}})
socketio = SocketIO(cors_allowed_origins="*", async_mode="eventlet")
socketio.init_app(app)


# endpoint for testing if the server is running correctly
@app.route('/', methods=['GET', 'POST'])
def home():
    return "<h1>Server is running correctly :)</h1>"


@socketio.on('connect')
def client_connect():
    session["roomId"] = ""
    emit('on_connect', 'Connected')


# print the username and the socket id of the user for debugging
@socketio.on('get_username')
def get_username(userName):
    print(userName + ' : ' + request.sid)


Rooms = {}


# print the rooms for debugging
def print_rooms():
    print("--------- Rooms ---------")
    for i in Rooms:
        print(f'{i} - {Rooms[i]}')
    print("------------------------")


# close the room and remove it from the Rooms dictionary for debugging
def close_and_remove_rooms(id):
    if id in Rooms:
        close_room(id)
        Rooms.pop(id)
        print_rooms()


@socketio.on('disconnect')
def disconnect():
    emit('on_disconnect', 'backend not connected')
    if session["roomId"] != "":
        emit("game_over", "Oponent DC'ed :(", to=session["roomId"])
        close_and_remove_rooms(session["roomId"])
        print(session["roomId"] + " is the roomid of someone who just dc'ed")
    else:
        print("random DC")


@socketio.on('user_join_room')
def user_join_room(data):
    username = data['username']
    for i in Rooms:
        # if room has one member another member can join
        if Rooms[i] == 1:
            room_id = i
            join_room(i)
            Rooms[i] += 1
            # set the player value to O and room_id in client
            room_id_and_player = {"room_id": room_id, "player": "O"}
            emit("set_current_player_and_room_id", room_id_and_player)
            session["roomId"] = room_id
            emit("match_found", to=room_id)
            break

    # if no room with one member, create one with the given room id
    else:
        room_id = data['room_id']
        join_room(room_id)
        # set player value to X and room_id in client
        room_id_and_player = {"room_id": room_id, "player": "X"}
        emit("set_current_player_and_room_id", room_id_and_player)
        session["roomId"] = room_id
        emit("waiting_for_opponent", to=room_id)
        Rooms[room_id] = 1

    print(username + ' has entered the room - ' + room_id)
    send(username + ' has entered the room - ' + room_id, to=room_id)
    print_rooms()


@socketio.on('sendUserName')
def send_user_name(data):
    emit("setOppName", data["name"], to=data["roomid"], include_self=False)


@socketio.on('board_changed')
def board_changed(data):
    data_to_send = {"x": data["x"], "y": data["y"], "player": data["player"]}
    emit("board_changed_in_server", data_to_send, to=data['roomId'], include_self=False)


@socketio.on('switch_users')
def switch_users(room_id):
    emit('make_user_switch', to=room_id, include_self=False)


@socketio.on('someone_won')
def someone_won(data):
    message = data["player"] + " Won!"
    emit("game_over", message, to=data["roomId"])
    close_and_remove_rooms(data["roomId"])

    print("Player " + data["player"] + " won in room -> " + data["roomId"])


@socketio.on('draw')
def draw(data):
    message = "It's a draw, play again!"
    emit("game_over", message, to=data["roomId"])
    close_and_remove_rooms(data["roomId"])


if __name__ == "__main__":
    socketio.run(app, port=3000, use_reloader=True, debug=True, log_output=True)
