from pydantic import BaseModel


class LeagueBase(BaseModel):
    league_name : str

class UserLoginBase(BaseModel):
    user_id: int
    user_type: str
    user_email: bool
    user_password: bool

class UserCreate(BaseModel):
    user_type: str
    user_email: str
    user_password: str

class User(BaseModel):
    user_email: str
    user_password: str

class PlayerCreate(BaseModel):
    player_email: str
    player_password: str
    player_firstname: str 
    player_surname: str 
    player_dob: str 
    player_height: str
    player_gender: str
    player_contact_number: str
    player_image: bytes

class SportBase(BaseModel):
    sport_name : str

class ManagerCreate(BaseModel):
    manager_email: str
    manager_password: str
    manager_firstname: str 
    manager_surname: str 
    manager_contact_number: str
    manager_image: bytes

class PhysioCreate(BaseModel):
    physio_email: str
    physio_password: str
    physio_firstname: str 
    physio_surname: str 
    physio_contact_number: str

class CoachCreate(BaseModel):
    coach_email: str
    coach_password: str
    coach_firstname: str
    coach_surname: str
    coach_contact: str
    coach_image: bytes

class Coach(BaseModel):
    coach_id: int
    coach_email: str
    coach_password: str

class CoachInfo(BaseModel):
    coach_id: int
    coach_firstname: str
    coach_surname: str
    coach_contact: str
    coach_image: bytes


class Manager(BaseModel):
    manager_id: int
    manager_email: str
    manager_password: str

class ManagerInfo(BaseModel):
    manager_id: int
    manager_firstname: str
    manager_surname: str
    manager_contact_number: str
    manager_image: bytes

class ManagerNoID(BaseModel):
    manager_email: str
    manager_password: str
    manager_firstname: str
    manager_surname: str
    manager_contact_number: str
    manager_image: bytes

class Physio(BaseModel):
    physio_id: int
    physio_email: str
    physio_password: str
    
class PhysioInfo(BaseModel):
    physio_id: int
    physio_firstname: str
    physio_surname: str
    physio_contact_number: str

class PhysioNoID(BaseModel):
    physio_email: str
    physio_password: str
    physio_firstname: str
    physio_surname: str
    physio_contact_number: str
    # physio_image: bytes

class TeamBase(BaseModel):
    team_name: str
    team_logo: bytes
    manager_id: int
    league_id: int
    sport_id: int
    team_location: str

class PlayerLogin(BaseModel):
    player_email: str
    player_password: str

class PlayerBase(BaseModel):
    player_id: int
    player_email: str
    player_password: str
    # player_firstname: str 
    # player_surname: str 
    # player_dob: str 
    # player_contact_number: str
    # player_image: bytes
    # matches_played: int
    # matches_started: int 
    # matches_off_the_bench: int
    # injury_prone: bool
    # minutes_played: int

class PlayerInfo(BaseModel):
    player_id: int
    player_firstname: str 
    player_surname: str 
    player_dob: str 
    player_contact_number: str
    player_image: bytes
    player_height: str
    player_gender: str

class PlayerStat(BaseModel): 
    player_id: int
    matches_played: int
    matches_started: int
    matches_off_the_bench: int
    injury_prone: bool
    minutes_played: int
    
class InjuryBase(BaseModel):
    injury_type: str
    expected_recovery_time: str
    recovery_method: str

class PlayerInjuryBase(BaseModel):
    injury_id: int
    date_of_injury: str
    date_of_recovery: str
    player_id: int

class TeamPlayerBase(BaseModel):
    team_id: int
    player_id: int
    team_position: str

class TeamCoachBase(BaseModel):
    team_id: int
    coach_id: int
    team_role: str
    
class TeamPhysioBase(BaseModel):
    team_id: int
    physio_id: int

class TeamPlayerDelete(BaseModel):
    team_id: int
    player_id: int

class ScheduleBase(BaseModel):
    schedule_id: int
    schedule_type: str
    schedule_start_time: str
    schedule_end_time: str

class TeamScheduleBase(BaseModel):
    schedule_id: int
    team_id: int
    schedule_date: str