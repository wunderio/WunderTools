import React from 'react';
import TestItemCheckbox from './TestItemCheckbox';

class TestItem extends React.Component {
  render() {
    return (
      <div className="row">
        <div className="col-md-12">
          <TestItemCheckbox
            test={this.props.test}
            allTests={this.props.allTests}
            updateTestsState={this.props.updateTestsState}/>
        </div>
      </div>
    )
  }
}

export default TestItem;