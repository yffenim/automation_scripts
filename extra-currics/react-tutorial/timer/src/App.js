import logo from './logo.svg';
import './App.css';
import React, { Component } from 'react';

function FormattedDate(props) {
  return <h2>It is {props.date.toLocaleTimeString()}.</h2>;
}

class Clock extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      date: new Date(),
      interval: 1000
    };
    this.handleClick = this.handleClick.bind(this);
  }

  componentDidMount() {
    this.timerID = setInterval(
      () => this.tick(),
      this.state.interval
    );
  }

  componentWillUnmount() {
    clearInterval(this.timerID);
  };
  
  tick() {
    this.setState({
      date: new Date()
    });
  };

  handleClick(value) {
    console.log(value)
    this.setState(prevState => {
      return {interval: value == 'faster' ? prevState.interval - 1000 : prevState.interval + 1000}
    });
    console.log(this.state.interval)
  }

// executes when component is updated, called after componentDidMount
  componentDidUpdate(prevProps, prevState){
    if (prevState.interval != this.state.interval) {
      clearInterval(this.timerID);
      this.timerID = setInterval(
      () => this.tick(),
      this.state.interval
      )
    }
  }
  
  render() {
    return (
      <div>
        <FormattedDate date={this.state.date} />
        <p>Current Interval: {this.state.interval} </p>
        <button 
          onClick={this.handleClick.bind(this, 'faster')}
        > Faster! </button>
        <button 
          style={{marginRight: '20px', marginLeft: '20px'}}
          onClick={this.handleClick.bind(this, 'slower')}
      > Slower! </button>
        <button
          onClick={() => this.setState ({ interval: 1000 })}
        > Reset! </button>
      </div>
    );
  }
}

// exporting the parent class function to that it can be imported on index.js
export default Clock;
