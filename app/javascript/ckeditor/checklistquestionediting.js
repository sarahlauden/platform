import Plugin from '@ckeditor/ckeditor5-core/src/plugin';
import { toWidget, toWidgetEditable } from '@ckeditor/ckeditor5-widget/src/utils';
import Widget from '@ckeditor/ckeditor5-widget/src/widget';
import InsertChecklistQuestionCommand from './insertchecklistquestioncommand';
import InsertCheckboxCommand from './insertcheckboxcommand';

export default class ChecklistQuestionEditing extends Plugin {
    static get requires() {
        return [ Widget ];
    }

    init() {
        this._defineSchema();
        this._defineConverters();

        this.editor.commands.add( 'insertChecklistQuestion', new InsertChecklistQuestionCommand( this.editor ) );
        this.editor.commands.add( 'insertCheckbox', new InsertCheckboxCommand( this.editor ) );
    }

    _defineSchema() {
        const schema = this.editor.model.schema;

        schema.register( 'checklistQuestion', {
            // Behaves like a self-contained object (e.g. an image).
            isObject: true,

            // Allow in places where other blocks are allowed (e.g. directly in the root).
            allowIn: 'section',

            // Each content part preview has an ID. A unique ID tells the application which
            // checklist-question it represents and makes it possible to render it inside a widget.
            allowAttributes: [ 'id' ]
        } );

        schema.register( 'question', {
            // Behaves like a self-contained object (e.g. an image).
            isObject: true,

            allowIn: 'checklistQuestion',
        } );

        schema.register( 'questionTitle', {
            // Cannot be split or left by the caret.
            isLimit: true,

            allowIn: 'question',

            // Allow content which is allowed in blocks (i.e. text with attributes).
            allowContentOf: '$block'
        } );

        schema.register( 'questionForm', {
            // Cannot be split or left by the caret.
            isLimit: true,

            allowIn: 'question',

            // Allow content which is allowed in the root (e.g. paragraphs).
            allowContentOf: ['questionFieldset'],
        } );

        schema.register( 'questionFieldset', {
            // Cannot be split or left by the caret.
            isLimit: true,

            allowIn: 'questionForm',

            // Allow content which is allowed in the root (e.g. paragraphs).
            //allowContentOf: ['questionLegend', 'checkbox'],
        } );

        schema.register( 'questionLegend', {
            // Cannot be split or left by the caret.
            isLimit: true,

            allowIn: 'questionFieldset',

            // Allow content which is allowed in blocks (i.e. text with attributes).
            allowContentOf: '$block'
        } );

        schema.register( 'checkboxDiv', {
            // Cannot be split or left by the caret.
            //isLimit: true,

            allowIn: 'questionFieldset',
            //allowIn: 'section',

            // Allow content which is allowed in blocks (i.e. text with attributes).
            allowContentOf: '$root',
        } );

        schema.register( 'checkboxInput', {
            // Cannot be split or left by the caret.
            //isLimit: true,
            isInline: true,

            allowIn: 'checkboxDiv',

            // Allow content which is allowed in blocks (i.e. text with attributes).
            //allowContentOf: '$block',

            allowAttributes: [ 'id', 'name', 'value' ]
        } );

        schema.register( 'checkboxLabel', {
            // Cannot be split or left by the caret.
            //isLimit: true,
            isInline: true,

            allowIn: 'checkboxDiv',

            // Allow content which is allowed in blocks (i.e. text with attributes).
            allowContentOf: '$block',

            allowAttributes: [ 'for' ]
        } );

        schema.register( 'answer', {
            // Behaves like a self-contained object (e.g. an image).
            isObject: true,

            allowIn: 'checklistQuestion'
        } );

        schema.register( 'answerTitle', {
            // Cannot be split or left by the caret.
            isLimit: true,

            allowIn: 'answer',

            // Allow content which is allowed in blocks (i.e. text with attributes).
            allowContentOf: '$block'
        } );

        schema.register( 'answerText', {
            // Cannot be split or left by the caret.
            isLimit: true,

            allowIn: 'answer',

            // Allow content which is allowed in the root (e.g. paragraphs).
            allowContentOf: '$root'
        } );

        schema.addChildCheck( ( context, childDefinition ) => {
            // Note that the context is automatically normalized to a SchemaContext instance and
            // the child to its definition (SchemaCompiledItemDefinition).

            // If checkChild() is called with a context that ends with blockQuote and blockQuote as a child
            // to check, make the checkChild() method return false.
            if ( context.endsWith( 'answerText' ) && childDefinition.name == 'checklistQuestion' ) {
                return false;
            }
        } );
    }

    _defineConverters() {
        const editor = this.editor;
        const conversion = editor.conversion;
        const { editing, data, model } = editor;

        /*
        editor.commands.get( 'enter' ).on( 'execute', (evt, data, three, four) => {
	    const positionParent = editor.model.document.selection.getLastPosition().parent;
	    if ( positionParent.name == 'checkboxLabel' ) {
                editor.model.change( writer => {
                        console.log('enter>>>>>>>>>>>');
                        console.log(writer, positionParent);
                        console.log(evt, data, three, four);
                        console.log('enter<<<<<<<<<<<');
                        //alert('omg');

                        editor.execute( 'insertCheckbox')

const fieldset = positionParent.parent.parent;


    const checkboxDiv = writer.createElement( 'checkboxDiv' );
    const checkboxInput = writer.createElement( 'checkboxInput' );
    const checkboxLabel = writer.createElement( 'checkboxLabel' );

    writer.append( checkboxInput, checkboxDiv );
    writer.append( checkboxLabel, checkboxDiv );

    //writer.insert( writer.createPositionAt( fieldset, 0 ), checkboxDiv );

    console.log(data);
				data.preventDefault();
				evt.stop();
                });
            }
        });
        */
        		this.listenTo( editing.view.document, 'enter', ( evt, data ) => {
			const doc = this.editor.model.document;
			const positionParent = doc.selection.getLastPosition().parent;
	                        if ( positionParent.name == 'checkboxLabel' ) {
			            alert('here');
                                    editor.execute( 'insertCheckbox')

				    data.preventDefault();
				    evt.stop();
	                	}
			});




        // <checklistQuestion> converters ((data) view → model)
        conversion.for( 'upcast' ).elementToElement( {
            view: {
                name: 'div',
                classes: ['module-block', 'module-block-checkbox']
            },
            model: ( viewElement, modelWriter ) => {
                // Read the "data-id" attribute from the view and set it as the "id" in the model.
                console.log(" up");
                return modelWriter.createElement( 'checklistQuestion', {
                    id: parseInt( viewElement.getAttribute( 'data-id' ) )
                } );
            }
        } );

        // <checklistQuestion> converters (model → data view)
        conversion.for( 'dataDowncast' ).elementToElement( {
            model: 'checklistQuestion',
            view: ( modelElement, viewWriter ) => {
                console.log("data down");
                return viewWriter.createEditableElement( 'div', {
                    class: 'module-block module-block-checkbox',
                    'data-id': modelElement.getAttribute( 'id' )
                } );
            }
        } );

        // <checklistQuestion> converters (model → editing view)
        conversion.for( 'editingDowncast' ).elementToElement( {
            model: 'checklistQuestion',
            view: ( modelElement, viewWriter ) => {
                // In the editing view, the model <checklistQuestion> corresponds to:
                //
                // <section class="checklist-question" data-id="...">
                //     <div class="checklist-question__react-wrapper">
                //         <ChecklistQuestion /> (React component)
                //     </div>
                // </section>
                const id = modelElement.getAttribute( 'id' );
                console.log("ed down");

                // The outermost <section class="checklist-question" data-id="..."></section> element.
                const checklistQuestion = viewWriter.createContainerElement( 'div', {
                    class: 'module-block module-block-checkbox',
                    'data-id': id
                } );

                // The inner <div class="checklist-question__react-wrapper"></div> element.
                // This element will host a React <ChecklistQuestion /> component.
                //const question = viewWriter.createUIElement( 'div', {
                //    class: 'question'
                //} );

                //viewWriter.insert( viewWriter.createPositionAt( checklistQuestion, 0 ), question );

                return toWidget( checklistQuestion, viewWriter, { label: 'checklist-question widget' } );
            }
        } );

        // <question> converters
        conversion.for( 'upcast' ).elementToElement( {
            model: 'question',
            view: {
                name: 'div',
                classes: 'question'
            }
        } );
        conversion.for( 'dataDowncast' ).elementToElement( {
            model: 'question',
            view: {
                name: 'div',
                classes: 'question'
            }
        } );
        conversion.for( 'editingDowncast' ).elementToElement( {
            model: 'question',
            view: ( modelElement, viewWriter ) => {
                const section = viewWriter.createContainerElement( 'div', { class: 'question' } );

                return toWidget( section, viewWriter );
            }
        } );

        // <questionTitle> converters
        conversion.for( 'upcast' ).elementToElement( {
            model: 'questionTitle',
            view: {
                name: 'h5'
            }
        } );
        conversion.for( 'dataDowncast' ).elementToElement( {
            model: 'questionTitle',
            view: {
                name: 'h5'
            }
        } );
        conversion.for( 'editingDowncast' ).elementToElement( {
            model: 'questionTitle',
            view: ( modelElement, viewWriter ) => {
                // Note: You use a more specialized createEditableElement() method here.
                const h5 = viewWriter.createEditableElement( 'h5', {
                } );

                return toWidgetEditable( h5, viewWriter );
            }
        } );

        // <questionForm> converters
        conversion.for( 'upcast' ).elementToElement( {
            model: 'questionForm',
            view: {
                name: 'form'
            }
        } );
        conversion.for( 'dataDowncast' ).elementToElement( {
            model: 'questionForm',
            view: {
                name: 'form'
            }
        } );
        conversion.for( 'editingDowncast' ).elementToElement( {
            model: 'questionForm',
            view: ( modelElement, viewWriter ) => {
                const form = viewWriter.createContainerElement( 'form' );

                return toWidget( form, viewWriter );
            }
        } );

        // <questionFieldset> converters
        conversion.for( 'upcast' ).elementToElement( {
            model: 'questionFieldset',
            view: {
                name: 'fieldset'
            }
        } );
        conversion.for( 'dataDowncast' ).elementToElement( {
            model: 'questionFieldset',
            view: {
                name: 'fieldset'
            }
        } );
        conversion.for( 'editingDowncast' ).elementToElement( {
            model: 'questionFieldset',
            view: ( modelElement, viewWriter ) => {
                const fieldset = viewWriter.createContainerElement( 'fieldset' );

                return toWidget( fieldset, viewWriter );
            }
        } );

        // <checkboxDiv> converters
        conversion.for( 'upcast' ).elementToElement( {
            model: 'checkboxDiv',
            view: {
                name: 'div'
            }

        } );
        conversion.for( 'dataDowncast' ).elementToElement( {
            model: 'checkboxDiv',
            view: {
                name: 'div'
            }
        } );
        conversion.for( 'editingDowncast' ).elementToElement( {
            model: 'checkboxDiv',
            view: ( modelElement, viewWriter ) => {
                // Note: You use a more specialized createEditableElement() method here.
                const div = viewWriter.createEditableElement( 'div', {} );


		const widgetContents = viewWriter.createUIElement(
			'select',
			null,
			function( domDocument ) {
				const domElement = this.toDomElement( domDocument );
				const correctness = modelElement.getAttribute( 'data-correctness' );
				domElement.innerHTML = `<select name="test">
    <option value="correct">Correct</option>
    <option value="incorrect">Incorrect</option>
    <option value="maybe">Maybe</option></select>`;
				return domElement;
			} );

		const insertPosition = viewWriter.createPositionAt( div, 0 );
		viewWriter.insert( insertPosition, widgetContents );




                return toWidgetEditable( div, viewWriter );
            }
        } );

        // <checkbox> converters
        conversion.for( 'upcast' ).elementToElement( {
            model: 'checkboxInput',
            view: {
                name: 'input',
                type: 'checkbox'
            }

        } );
        conversion.for( 'dataDowncast' ).elementToElement( {
            model: 'checkboxInput',
            view: ( modelElement, viewWriter ) => {
                // Note: You use a more specialized createEditableElement() method here.
                const input = viewWriter.createEmptyElement( 'input', {'type': 'checkbox'} );
                return input;
            }
        } );
        conversion.for( 'editingDowncast' ).elementToElement( {
            model: 'checkboxInput',
            view: ( modelElement, viewWriter ) => {
                // Note: You use a more specialized createEditableElement() method here.
                const input = viewWriter.createEmptyElement( 'input', {'type': 'checkbox'} );
                return toWidget( input, viewWriter );
            }
        } );

        // <checkbox> converters
        conversion.for( 'upcast' ).elementToElement( {
            model: 'checkboxLabel',
            view: {
                name: 'label'
            }

        } );
        conversion.for( 'dataDowncast' ).elementToElement( {
            model: 'checkboxLabel',
            view: {
                name: 'label'
            }
        } );
        conversion.for( 'editingDowncast' ).elementToElement( {
            model: 'checkboxLabel',
            view: ( modelElement, viewWriter ) => {
                // Note: You use a more specialized createEditableElement() method here.
                const label = viewWriter.createEditableElement( 'label', {} );

                return toWidgetEditable( label, viewWriter );
            }
        } );

        // <answer> converters
        conversion.for( 'upcast' ).elementToElement( {
            model: 'answer',
            view: {
                name: 'div',
                classes: 'answer'
            }
        } );
        conversion.for( 'dataDowncast' ).elementToElement( {
            model: 'answer',
            view: {
                name: 'div',
                classes: 'answer'
            }
        } );
        conversion.for( 'editingDowncast' ).elementToElement( {
            model: 'answer',
            view: ( modelElement, viewWriter ) => {
                const section = viewWriter.createContainerElement( 'div', { class: 'answer' } );

                return toWidget( section, viewWriter );
            }
        } );

        // <answerTitle> converters
        conversion.for( 'upcast' ).elementToElement( {
            model: 'answerTitle',
            view: {
                name: 'h5'
            }
        } );
        conversion.for( 'dataDowncast' ).elementToElement( {
            model: 'answerTitle',
            view: {
                name: 'h5'
            }
        } );
        conversion.for( 'editingDowncast' ).elementToElement( {
            model: 'answerTitle',
            view: ( modelElement, viewWriter ) => {
                // Note: You use a more specialized createEditableElement() method here.
                const h5 = viewWriter.createEditableElement( 'h5', {} );

                return toWidgetEditable( h5, viewWriter );
            }
        } );

        // <answerText> converters
        conversion.for( 'upcast' ).elementToElement( {
            model: 'answerText',
            view: {
                name: 'div'
            }
        } );
        conversion.for( 'dataDowncast' ).elementToElement( {
            model: 'answerText',
            view: {
                name: 'div'
            }
        } );
        conversion.for( 'editingDowncast' ).elementToElement( {
            model: 'answerText',
            view: ( modelElement, viewWriter ) => {
                // Note: You use a more specialized createEditableElement() method here.
                const div = viewWriter.createEditableElement( 'div', {} );

                return toWidgetEditable( div, viewWriter );
            }
        } );

    }
}
