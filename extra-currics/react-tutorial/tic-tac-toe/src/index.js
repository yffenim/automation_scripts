import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';

// to remember things, components use state

// show the value of of the prop called value using Square's render method
// we are passing a FUNCTION as the on click prop -- not saying that you fire everytime on click

// class Square extends React.Component {

// add a constructor to the class to intialize the state
// components can have state by setting this.state in their constructors
// this.state is private to the component
// call super when defining the constructor of a subclass
// constructor no longer needed because Square does not keep track of the game state 
//  constructor(props) {
//    super(props);
//    this.state = {
//      value: null,
//    };
//  }

// render is a method that returns a description for views
  // calling this.setState from an onClick handler in the Square's renter method will tell React to re-render that Square whenver it's button is clicked
  // child components are automatically updated

//render() {
 //   return (

      // set up an onClick prop in the button function
// when clicked, React will call the onCLick event handler from the Square class render() method
// event handler calls this.props.onClick()
// since the board passsed the onClikc to Square as a function, the Square callsd the Boar'd handleClick(i) when clicked
 //     <button 
 //       className="square" 
 //       onClick={() => this.props.onClick()}
//     >
//        {this.props.value}
//      </button>
//    );
//  }
//}

function Square(props) {
  return (
    <button className="square" onClick=
{props.onClick}>
      {props.value}
    </button>
  );
}

// board renders square component 
class Board extends React.Component {
// method renderSquare passses prop called value to the Square component
// how do we know this is the parent of square?
// render square one of its functions returning the Square component 

// we want to store the game's state in the parent board component which can pass the state back down to the children using props so that the children components are in sync with each other and with parent. This is done using constructor:

  constructor(props) {
    super(props);
    this.state = {
      squares: Array(9).fill(null),
      xIsNext: true,
    };
  }

// what to do with the square is clicked and the click is passed on to the board's click handler
  handleClick(i) {
    const squares = this.state.squares.slice();
    if (calculateWinner(squares) || squares[i]) {
      return;
    }
    squares[i] = 'X';
    this.setState({
      squares: squares,
      xIsNext: !this.state.xIsNext,
    });
  }
// since state is stored in board, when board's state changes, the square components re-render automatically.
// square componenents receive values from board and tell oard when they are clicked: they are now "controlled components"


// this method renderSquare is ignored because we have specified the square's own state
  renderSquare(i) {
    return (
// pass a function from board to square because we can't access the game state from square since state is private. This function will have Square class call it when clicked.
      <Square 
        value={this.state.squares[i]}
        onClick={() => this.handleClick(i)}
      />
    );
  }
// call the calculate winners function from board class render function
  render() {
    const winner = calculateWinner(this.state.squares);
    let status;
    if (winner) {
      status = 'Winner: ' + winner;
    } else {
      status = 'Next player: ' + (this.state.xIsNext ? 'X' : 'O');
    }
    return (
      <div>
        <div className="status">{status}</div>
        <div className="board-row">
          {this.renderSquare(0)}
          {this.renderSquare(1)}
          {this.renderSquare(2)}
        </div>
        <div className="board-row">
          {this.renderSquare(3)}
          {this.renderSquare(4)}
          {this.renderSquare(5)}
        </div>
        <div className="board-row">
          {this.renderSquare(6)}
          {this.renderSquare(7)}
          {this.renderSquare(8)}
        </div>
      </div>
    );
  }
}

class Game extends React.Component {
  render() {
    return (
      <div className="game">
        <div className="game-board">
          <Board />
        </div>
        <div className="game-info">
          <div>{/* status */}</div>
          <ol>{/* TODO */}</ol>
        </div>
      </div>
    );
  }
}

// ========================================

ReactDOM.render(
  <Game />,
  document.getElementById('root')
);

function calculateWinner(squares) {
  const lines = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];
  for (let i = 0; i < lines.length; i++) {
    const [a, b, c] = lines[i];
    if (squares[a] && squares[a] === squares[b] && squares[a] === squares[c]) {
      return squares[a];
    }
  }
  return null;
}

