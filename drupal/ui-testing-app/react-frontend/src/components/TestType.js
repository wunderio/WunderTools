import React from 'react';
import TestItem from './TestItem';

class TestType extends React.Component {
  render() {
    return (
      <div className="card" style={{margin: '20px'}}>
        <h5 className="card-header">{this.props.testType} tests</h5>
        <div className="card-body text-left">
          {/*<h5 className="card-title"></h5>*/}
          <div className="card-text">
            <div className="container-fluid">
              {
                Object.keys(this.props.tests).map(key =>
                  <TestItem
                    key={key}
                    test={this.props.tests[key]}
                    allTests={this.props.allTests}
                    updateState={this.props.updateState}/>
                )
              }
            </div>
          </div>
        </div>
      </div>
    )
  }
}

export default TestType;