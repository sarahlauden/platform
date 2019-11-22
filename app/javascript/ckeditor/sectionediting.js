import Plugin from '@ckeditor/ckeditor5-core/src/plugin';
import { toWidget, toWidgetEditable } from '@ckeditor/ckeditor5-widget/src/utils';
import Widget from '@ckeditor/ckeditor5-widget/src/widget';
import InsertSectionCommand from './insertsectioncommand';

export default class SectionEditing extends Plugin {
    static get requires() {
        return [ Widget ];
    }

    init() {
        this._defineSchema();
        this._defineConverters();

        this.editor.commands.add( 'insertSection', new InsertSectionCommand( this.editor ) );
    }

    _defineSchema() {
        const schema = this.editor.model.schema;

        schema.register( 'section', {
            //isLimit: true,

            allowIn: '$root',

            // Allow content which is allowed in the root (e.g. paragraphs).
            allowContentOf: '$root',

            allowAttributes: [ 'id' ]
        } );

        schema.addChildCheck( ( context, childDefinition ) => {
            // Note that the context is automatically normalized to a SchemaContext instance and
            // the child to its definition (SchemaCompiledItemDefinition).

            // If checkChild() is called with a context that ends with blockQuote and blockQuote as a child
            // to check, make the checkChild() method return false.
            if ( context.endsWith( 'section' ) && childDefinition.name == 'section' ) {
                return false;
            }
        } );
    }

    _defineConverters() {
        const editor = this.editor;
        const conversion = editor.conversion;

        // <section> converters ((data) view → model)
        conversion.for( 'upcast' ).elementToElement( {
            view: {
                name: 'section',
                classes: ['content-section']
            },
            model: ( viewElement, modelWriter ) => {
                // Read the "data-id" attribute from the view and set it as the "id" in the model.
                console.log(" up");
                return modelWriter.createElement( 'section', {
                    id: parseInt( viewElement.getAttribute( 'data-id' ) )
                } );
            }
        } );

        // <section> converters (model → data view)
        conversion.for( 'dataDowncast' ).elementToElement( {
            model: 'section',
            view: ( modelElement, viewWriter ) => {
                console.log("data down");
                return viewWriter.createEditableElement( 'section', {
                    class: 'content-section',
                    'data-id': modelElement.getAttribute( 'id' )
                } );
            }
        } );

        // <section> converters (model → editing view)
        conversion.for( 'editingDowncast' ).elementToElement( {
            model: 'section',
            view: ( modelElement, viewWriter ) => {
                // In the editing view, the model <section> corresponds to:
                //
                // <section class="..." data-id="...">
                // </section>
                const id = modelElement.getAttribute( 'id' );
                console.log("ed down");

                // The outermost <section class="checklist-question" data-id="..."></section> element.
                const section = viewWriter.createEditableElement( 'section', {
                    class: 'content-section',
                    'data-id': id
                } );

                return toWidgetEditable( section, viewWriter, { label: 'section widget' } );
            }
        } );
    }
}
