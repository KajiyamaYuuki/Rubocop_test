class AgendasController < ApplicationController
  before_action :set_agenda, only: %i[destroy]
  before_action :ensure_destroyer, only: %i[destroy]

  def index
    @agendas = Agenda.all
  end

  def new
    @team = Team.friendly.find(params[:team_id])
    @agenda = Agenda.new
  end

  def create
    @agenda = current_user.agendas.build(title: params[:title])
    @agenda.team = Team.friendly.find(params[:team_id])
    current_user.keep_team_id = @agenda.team.id
    if current_user.save && @agenda.save
      redirect_to dashboard_url, notice: I18n.t('views.messages.create_agenda')
    else
      render :new
    end
  end

  def destroy
    @agenda.destroy
    # @users = Assign.where(team_id: @agenda.team_id).map(&:user)
    @users = Team.find(@agenda.team_id).members
    AgendaMailer.send_mail_users(@users)
    redirect_to dashboard_url, notice: I18n.t('views.messages.delete_agenda')
  end

  private

  def set_agenda
    @agenda = Agenda.find(params[:id])
  end

  def agenda_params
    params.fetch(:agenda, {}).permit %i[title description]
  end

  def ensure_destroyer
    if current_user.id != @agenda[:user_id].to_i && current_user.id != @agenda.team.owner_id
      flash[:notice] = '権限がありません'
      redirect_to dashboard_url
    end
  end
end
