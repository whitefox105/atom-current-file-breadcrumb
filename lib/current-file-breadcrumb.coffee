CurrentFileBreadcrumbView = require './current-file-breadcrumb-view'
{CompositeDisposable} = require 'atom'

module.exports = CurrentFileBreadcrumb =
  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    @breadcrumbViews = []

    paneSubscription = atom.workspace.observePanes (pane) =>
      breadcrumbView = new CurrentFileBreadcrumbView
      @breadcrumbViews.push(breadcrumbView)

      paneElement = atom.views.getView(pane)
      paneElement.insertBefore(breadcrumbView.getElement(), paneElement.firstChild)

      pane.onDidDestroy => @unsubscribe()

    @subscriptions.add paneSubscription
    @subscriptions.add atom.commands.add 'atom-workspace', 'current-file-breadcrumb:toggle': => @toggle()

  unsubscribe: ->
    @subscriptions.dispose()
    view.destroy() for view in @breadcrumbViews

  deactivate: ->
    @unsubscribe()
    console.log 'deactivate'

  toggle: ->
    console.log 'CurrentFileBreadcrumb was toggled!'
