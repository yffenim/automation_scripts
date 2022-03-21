import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import Clock from './App';
import reportWebVitals from './reportWebVitals';

// we call the App.js component

ReactDOM.render(
  <React.StrictMode>
    <Clock />
    <Clock />
    <Clock />
  </React.StrictMode>,
  document.getElementById('root')
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
