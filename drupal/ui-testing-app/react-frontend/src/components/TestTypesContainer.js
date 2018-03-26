import React from 'react';
import TestType from './TestType';

class TestTypesContainer extends React.Component {

  // TODO: Make as a helper function
  filterTestByType = (data, type) => {
    return Object.values(data).filter(test => test.type === type);
  };

  render() {
    return (
      <div className="container-fluid App-intro">
        <div className="row">
          <div className="col-md-12">
            <h2 className="mt-4">Choose tests you would like to run...</h2>
          </div>
        </div>
        <div className="row">
          <div className="col-md-12">
            {
              Object.keys(this.props.testTypes).map(key =>
                <TestType
                  key={key}
                  testType={this.props.testTypes[key]}
                  tests={this.filterTestByType(this.props.tests, this.props.testTypes[key])}
                  allTests={this.props.tests}
                  updateTestsState={this.props.updateTestsState}/>
              )
            }
          </div>
        </div>
      </div>
    )
  }
}

export default TestTypesContainer;