import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';

// to remember things, components use state

// show the value of of the prop called value using Square's render method
// we are passing a FUNCTION as the on click prop -- not saying that you fire everytime on click
class Square extends React.Component {
// add a constructor to the class to intialize the state
// components can have state by setting this.state in their constructors
// this.state is private to the component
// call super when defining the constructor of a subclass
  constructor(props) {
    super(props);
    this.state = {
      value: null,
    };
  }

// render is a method that returns a description for views
  // calling this.setState from an onClick handler in the Square's renter method will tell React to re-render that Square whenver it's button is clicked
  render() {
    return (
      <button className="square" onClick={() => this.setState({value: 'X'})}>
        {this.state.value}
      </button>
    );
  }
}

// board renders square component 
class Board extends React.Component {
// method renderSquare passses prop called value to the Square component
// how do we know this is the parent of square?
// render square one of its functions returning the Square component 
  renderSquare(i) {
    return <Square value={i} />;
  }

  render() {
    const status = 'Next player: X';

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

