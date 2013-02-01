# ## Fondant
#
# HTML5 WYSIWYG Editor
#
# Fondant is the icing on the cake for user input.
#
# &copy; 2013 [Phillip Ridlen][1] & [Oven Bits, LLC][2]
#
#   [1]: http://phillipridlen.com
#   [2]: http://ovenbits.com


# ## Usage
#
# ### Instantiation
#
# To launch the editor on a specific element:
#
#     $('div.editable').fondant();
#
# You can also use it on a `<textarea>` and it will convert it to a `<div>`
# while the editor is on:
#
#     $('form#content textarea.wysiwyg').fondant();
#
# ### Options Reference
#
# * `cssPrefix` - prefix for all css classes and ids added to elements
#   generated by Fondant (default: `fondant-`)
#
# * `toolbar` - jQuery selector of the element to bind the editor
#   functions. If left blank, Fondant will generate a toolbar. (default:
#   `undefined`)
#


$ = jQuery

$ ->

  # ## Class Definition
  #
  # Defines the `Fondant` class that will be instantiated when `$.fn.fondant`
  # is called.
  #
  Fondant = (element, options) -> @init 'fondant', element, options

  Fondant.prototype =

    # ## Methods

    constructor: Fondant

    # ### init( type, element, options )
    #
    # Initializes the Fondant editor.
    #
    # Parameters:
    #
    # * `type` - should always be 'fondant' (see constructor above)
    # * `element` - enable the Fondant editor for this element
    # * `options` - overrides for the default options
    #
    init: (type, element, options) ->
      @id = new Date().getTime() / 100
      @type = type
      @$element = $(element)
      @options = @getOptions(options)

      @textarea = true if this.$element.prop('tagName') == 'textarea'

      @makeEditable()
      @insertToolbar()

    # ### destroy()
    #
    # Destroy the Fondant editor and any elements created by it
    #
    destroy: ->
      @removeToolbar()
      @makeUneditable()
      @$element.removeData(@type)

    # ### insertToolbar()
    #
    # Add the formatting toolbar and bind the editor functions
    #
    insertToolbar: ->
      console.log "Inserting toolbar... (j/k)"

    # ### removeToolbar()
    #
    # Remove the formatting toolbar and unbind the editor functions
    #
    removeToolbar: ->
      console.log "Removing toolbar... (j/k)"

    # ### getOptions( options )
    #
    # Get the options from the defaults, options passed to the constructor, and
    # the options set in the element's `data` attribute
    #
    getOptions: (options) ->
      options = $.extend {},
        $.fn[@type].defaults,  # default options
        options,               # options passed in to the constructor
        @$element.data()       # options set in the element's `data` attribute

    # ### makeEditable()
    #
    # Make the element editable. If it is a `<textarea>`, convert it to a
    # `<div>` first.
    #
    makeEditable: ->
      @$element = @replaceTextareaWithDiv(@$element) if @textarea
      @$element.attr 'contenteditable', 'true'

    # ### makeUneditable()
    #
    # Turns off `contenteditable` for this editor. If this editor was
    # originally a `<textarea>`, convert it back.
    #
    makeUneditable: ->
      @$element = @replaceDivWithTextarea(@$element) if @textarea
      @$element.attr 'contenteditable', 'false'

    # ### replaceElement( $old, fresh )
    #
    # Replace a jQuery element with a new one from a string. Returns the new
    # jQuery element.
    #
    replaceElement: ($old, fresh) ->
      $old.replaceWith($fresh = $(fresh))
      $fresh

    # ### replaceDivWithTextarea( $element, keep_changes = true )
    #
    # Swaps out the the `<div>` for a `<textarea>`, returning the original's
    # attributes. If keep_changes is false, put the original content back in.
    # Essentially reverses the process of `replaceTextareaWithDiv`.
    #
    replaceDivWithTextarea: ($element, keep_changes = true) ->
      html = $element.html()
      $element = @relpaceElement($element, @templates.textarea())
      $element.get(0).attributes = @textarea.attrs
      $element.val(html) if keep_changes else $element.val(@textarea.value)

    # ### replaceTextareaWithDiv( $element )
    #
    # Swaps out the `<textarea>` with a `<div>` so we can use contenteditable.
    # Saves the `<textarea>`'s value and attributes so it can be restored when
    # the editor gets canceled/destroyed.
    #
    replaceTextareaWithDiv: ($element) ->
      @textarea =
        value: $element.val()
        attrs: $element.get(0).attributes

      $element = @replaceElement($element, @templates.editor())
      $element.html(@textarea.value)


    # ## Formatting Functions
    #
    # These are the functions that make the magic happen.
    #
    format:
      # ### format.apply( command, value )
      #
      # Applies a rich text editor command to selection or block. Available
      # commands are [listed on the MDN website][1].
      #
      #   [1]: https://developer.mozilla.org/en-US/docs/Rich-Text_Editing_in_Mozilla
      #
      apply: (command, value) ->
        document.execCommand command, false, value

      # ### format.remove()
      #
      # Remove all formatting for selection
      #
      remove: -> @apply 'removeFormat'

      # ### Text Styles
      #
      # * `format.bold()`
      # * `format.italic()`
      bold:   -> @apply 'bold'
      italic: -> @apply 'italic'

      # ### Block Formats
      #
      # Wraps the selected element in a block element:
      #
      # * `format.p()`
      # * `format.h1()`
      # * `format.h2()`
      # * `format.h3()`
      # * `format.h4()`
      # * `format.blockquote()`
      #
      p:  -> @apply 'formatBlock', '<p>'
      h1: -> @apply 'formatBlock', '<h1>'
      h2: -> @apply 'formatBlock', '<h2>'
      h3: -> @apply 'formatBlock', '<h3>'
      h4: -> @apply 'formatBlock', '<h4>'
      blockquote: -> @apply 'formatBlock', '<blockquote>'

      # ### Lists and Indentation
      #
      # * `format.ol()`
      # * `format.ul()`
      # * `format.indent()`
      # * `format.outdent()`
      #
      ol:       -> @apply 'insertOrderedList'
      ul:       -> @apply 'insertUnorderedList'
      indent:   -> @apply 'indent'
      outdent:  -> @apply 'outdent'

      # ### Undo/Redo
      #
      # * `format.undo()`
      # * `format.redo()`
      #
      undo: -> @apply 'undo'
      redo: -> @apply 'redo'

      # ### Links
      #
      # * `format.link( url )`
      # * `format.unlink()`
      #
      link: (url) -> @apply 'createLink', url
      unlink:     -> @apply 'unlink'


    # ## HTML Templates
    #
    # Templates for inserted html elements 
    templates:

      # ### templates.editor()
      #
      # If a `<textarea>` is being swapped out for a `<div>`, this is the
      # function we'll use to generate the editor.
      #
      editor: ->
        """
        <div
          class="#{ @options.cssPrefix }-editor"
          id="#{@options.cssPrefix }-#{ @id }">
        </div>
        """

      # ### templates.textarea()
      #
      # When the `<textarea>` is restored, start with this.
      #
      textarea: -> "<textarea></textarea>"

      # ### templates.toolbar()
      #
      toolbar: ->
        """
        <div class="#{ @options.cssPrefix }-toolbar" id="#{ @options.cssPrefix }-#{ @id }">
          <ul>
            <li><a href="#" data-action="#{ @type }-bold">B</a></li>
            <li><a href="#" data-action="#{ @type }-italic">I</a></li>
          </ul>
        </div>
        """


  # ## Plugin Setup
  #
  # ### jQuery function property
  #
  # Builds a fondant editor for each matched element.
  #
  $.fn.fondant = ->
    @each ->
      $this = $(this)
      data = $this.data('fondant')
      options = typeof option == 'object' && option
      if (!data)
        $this.data('fondant', (data = new Fondant(this, options)))
      if (typeof option == 'string')
        data[option]()

  $.fn.fondant.Contstructor = Fondant

  # ### Defaults
  #
  # Allows user to set their own defaults without having to pass in their
  # overrides on every instantiation
  #
  $.fn.fondant.defaults =
    cssPrefix: 'fondant-'

