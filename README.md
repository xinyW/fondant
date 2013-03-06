# Fondant v0.5.0

The icing on the cake for user input. A simple jQuery HTML5 WYSIWYG editor
using `contenteditable`.

&copy; 2013 [Phillip Ridlen][1] & [Oven Bits, LLC][2]

  [1]: http://phillipridlen.com
  [2]: http://ovenbits.com

## Requirements

* A recent jQuery (tested with 1.9.1)
* A modern-ish browser (IE9+)

## Usage

### Instantiation

To launch the editor on a block element or a text area:

```javascript
$('div.editable').fondant({
  // Default options
  prefix: 'fondant'   // prefix for all css classes and ids added to elements generated by Fondant

  toolbar: true,      // If set to `true`, Fondant will generate a generic toolbar. If set to a
                      // string or a function, it will use the value or return value of it for the
                      // toolbar html

  buttons: [          // You can pass in a subset of these buttons to only show certain ones. Will
    'bold',           // only work if `toolbar` is `true`. Otherwise the toolbar will not be
    'italic',         // generated or will use the custom string or function.
    'p',
    'h1',
    'h2',
    'h3',
    'h4',
    'blockquote',
    'ol',
    'ul',
    'indent',
    'outdent',
    'remove',
    'unlink',
    'undo',
    'redo'
  ]
});
```

### Commands

#### Formatting

If you choose to build your own toolbar, here are the commands to use. Note that because of the
nature of `document.execCommand()` these actions will apply to the currently selected text of _any_
contenteditable block element.

```javascript
// Insert Custom HTML (replaces currently selected text)
$('.fondant-editor').fondant('custom', html_string);

// Remove Formatting
$('.fondant-editor').fondant('remove');

// Font Style
$('.fondant-editor').fondant('bold');
$('.fondant-editor').fondant('italic');

// Block elements
$('.fondant-editor').fondant('p');
$('.fondant-editor').fondant('h1');
$('.fondant-editor').fondant('h2');
$('.fondant-editor').fondant('h3');
$('.fondant-editor').fondant('h4');
$('.fondant-editor').fondant('blockquote');

// Lists
$('.fondant-editor').fondant('ol');
$('.fondant-editor').fondant('ul');
$('.fondant-editor').fondant('indent');
$('.fondant-editor').fondant('outdent');

// Links
$('.fondant-editor').fondant('link', href);
$('.fondant-editor').fondant('unlink');
```

#### Fondant

```javascript
// Focus the editor
$('.fondant-editor').fondant('focus');

// Get or set the editor html
$('.fondant-editor').fondant('value');
$('.fondant-editor').fondant('value', html_string);

// Get the currently selected text
$('.fondant-editor').fondant('getSelection');
```

## Testing

To run the tests, first start CoffeScript watching and compiling:

```bash
coffee --watch --compile src/*.coffee spec/*.coffee
```

Then open `SpecRunner.html` in your browser to run the tests.

