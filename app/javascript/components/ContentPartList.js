import React from 'react';
import ContentPartPreview from './ContentPartPreview';

export default class ContentPartList extends React.Component {
    render() {
        return (
            <ul id="widget-list">
                {this.props.contentParts.map( contentPart => {
                    return (
                        <ContentPartPreview
                            id={contentPart.id}
                            key={contentPart.id}
                            onClick={this.props.onClick}
                            {...contentPart}
                        />
                    );
                })}
            </ul>
        );
    }
}
