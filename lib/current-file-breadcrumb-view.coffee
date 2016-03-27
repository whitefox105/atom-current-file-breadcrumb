{Disposable, CompositeDisposable} = require 'atom'

module.exports =
class CurrentFileBreadcrumbView
  constructor: ->
    @subscriptions = new CompositeDisposable()

    @rootPath = atom.project.getPaths()

    # Create root element
    @element = document.createElement('div')
    @element.classList.add('current-file-breadcrumb')

    @setActiveFilePath()
    @handleEvents()

  # Returns an object that can be retrieved when package is activated
  handleEvents: ->
    updatePath = =>
      @setActiveFilePath()
      console.log 'update'
      #@message.textContent = @activeFilePath()

    subscription = atom.workspace.onDidChangeActivePaneItem(updatePath)

    if Disposable.isDisposable(subscription)
        @subscriptions.add(subscription)
    else
      console.warn 'error'

  setActiveFilePath: ->
    @element.textContent = null;
    breadcrumb = document.createElement('div')
    breadcrumb.classList.add('breadcrumb')

    paths = @activeFilePath().split('/')
    paths[0] = '/'
    i = 1

    expandItem = (e) =>
      depth = e.target.getAttribute('data-depth')
      atom.commands.dispatch(atom.views.getView(atom.workspace), 'tree-view:reveal-active-file')

      treeView = atom.views.getView(atom.workspace.getLeftPanels()[0].getItem()
      for i in [1..depth]
        atom.commands.dispatch(treeView, 'tree-view:collapse-directory')
      atom.commands.dispatch(treeView, 'tree-view:expand-item')

    for name in paths
      item = document.createElement('a')
      item.setAttribute('data-depth', paths.length - i)
      item.addEventListener('click', expandItem)
      item.textContent = name

      breadcrumb.appendChild(item)
      i++

    @element.appendChild(breadcrumb)

  activeFilePath: ->
    editor = atom.workspace.getActivePaneItem()
    if typeof editor.getPath is 'function'
      editor?.getPath().replace(@rootPath, '')
    else
      ''

  # Tear down any state and detach
  destroy: ->
    console.log 'destroy'
    @element.remove()
    @subscriptions.dispose()

  getElement: ->
    @element
